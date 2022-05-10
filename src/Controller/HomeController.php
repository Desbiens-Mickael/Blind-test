<?php

namespace App\Controller;

use App\Model\UserManager;
use App\Service\User;

class HomeController extends AbstractController
{
    /**
     * Display home page
     */
    public function index(): string
    {
        $errors = [];
        if (!empty($_POST['nickname'])) {
            $_SESSION['user'] = new User();

            $userManager = new UserManager();
            $user = $userManager->selectOneByNickname($_POST['nickname']);
            if (!empty($user)) {
                $errors['user'] = "Pseudo déjà utilisé";
            } else {
                $_SESSION['user']->setNickname($_POST['nickname']);
                $userManager->add($_SESSION['user']->getNickname());
                header('location: /category');
            }
        }

        return $this->twig->render('Home/index.html.twig', [
            'errors' => $errors
        ]);
    }
}
