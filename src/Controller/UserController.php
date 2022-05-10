<?php

namespace App\Controller;

use App\Model\UserManager;
use App\Controller\AbstractController;

class UserController extends AbstractController
{
    public function login(): string|null
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST)) {
            $credentials = array_map('trim', $_POST);
            // @todo make some controls on email and password fields and if errors, send them to the view
            $userManager = new UserManager();
            // On demande au UserManager de rechercher l'utilisateur en BDD à partir de l'email
            $user = $userManager->selectByEmail($credentials['email']);
            // Si l'utilisateur a été trouvé et si l'empreinte de son mot de passe est vérifiée...
            if ($user && password_verify($credentials['password'], $user['password'])) {
                // ...alors on persiste l'id de notre utilisateur identifié dans la session PHP à l'index ['user_id']
                $_SESSION['user_id'] = $user['id'];
                // puis on le redirige sur une autre page (page catégories ici)
                header('Location: /category');
                return null;
            }
        }
        return $this->twig->render('User/login.html.twig');
    }

    public function register(): string|null
    {
        $errors = [];

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // 1. vérifier que le pseudo et l'email $credentials['nickname'] est disponible/valide
            if (!empty($_POST['nickname']) || !empty($_POST['email'])) {
                $credentials = $_POST;
                $userManager = new UserManager();
                $user = $userManager->selectOneByNickname($credentials['nickname']);
                $email = $userManager->selectByEmail($credentials['email']);
                //filter validate
                if (!empty($user)) {
                    $errors['user'] = "Pseudo déjà utilisé";
                } elseif (!empty($email)) {
                    $errors['email'] = "Veuillez saisir une adresse e-mail valide";
                } else {
                    $_SESSION['nickname'] = $_POST['nickname'];
                    $userManager->insert($credentials);
                    return $this->login();
                }

                // 3. vérifier que le mot de passe $credentials['password']
                if (!empty($_POST['password'])) {
                    $credentials = $_POST;
                    $userManager = new UserManager();
                    $user = $userManager->selectOneByNickname($credentials['password']);
                    if (!empty($user)) {
                        $errors['user'] = "Entrez une combinaisons d'au moins six chiffres,
                        lettres et signes de ponctuactions (tels que ! et &)";
                    } else {
                        $_SESSION['password'] = $_POST['password'];
                        $userManager->insert($credentials);
                        return $this->login();
                    }
                }
            }
        }
        return $this->twig->render('User/register.html.twig');
    }
}
