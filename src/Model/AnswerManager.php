<?php

namespace App\Model;

class AnswerManager extends AbstractManager
{
    public const TABLE = 'answer';

    public function selectOneByIdAndTitle(int $id, string $userAnswer): array|false
    {
        $statement = $this->pdo->prepare("SELECT title FROM " . self::TABLE .
            " WHERE track_id=:id AND SOUNDEX(LOWER(title)) = SOUNDEX(LOWER(:userAnswer))");
        $statement->bindValue(':id', $id, \PDO::PARAM_INT);
        $statement->bindValue(':userAnswer', $userAnswer, \PDO::PARAM_STR);
        $statement->execute();

        return $statement->fetch();
    }

    public function insert(array $answer, int $id): int
    {
        $statement = $this->pdo->prepare("INSERT INTO " . static::TABLE . " (title, `track_id`) VALUES (:answer, :id)");
        $statement->bindValue(':answer', $answer['title']);
        $statement->bindValue(':id', $id);

        $statement->execute();
        return (int)$this->pdo->lastInsertId();
    }

    public function selectByTitle(string $title): array
    {
        $statement = $this->pdo->prepare("SELECT title FROM " . self::TABLE .
            " WHERE title != :title ORDER BY RAND()");
        $statement->bindValue(':title', $title, \PDO::PARAM_STR);
        $statement->execute();

        return $statement->fetchAll();
    }

    public function update($track): bool
    {
        $query = "UPDATE " . self::TABLE . " SET `title`=:title WHERE track_id=:id";
        $statement = $this->pdo->prepare($query);
        $statement->bindValue('id', $track['id'], \PDO::PARAM_INT);
        $statement->bindValue('title', $track['title'], \PDO::PARAM_STR);

        return $statement->execute();
    }
}
