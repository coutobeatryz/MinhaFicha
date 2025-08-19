INSERT INTO academico.disciplinas (nome, codigo, carga_horaria)
VALUES ('aeds 1', 'csi488', 60);

INSERT INTO academico.disciplinas (nome, codigo, carga_horaria, pre_requisito_id)
VALUES (
    'banco de dados',
    'csi440',
    60,
    (SELECT disciplina_id FROM academico.disciplinas WHERE codigo = 'csi488')
);