create database escola
go
use escola
go
create table Curso(
	Id_Curso int not null identity(1,1),
	Nome varchar(50) not null,
	Sigla varchar(10) not null,
	constraint PK_Id_Curso primary key(Id_Curso),
	constraint Unique_Curso unique(Nome, Sigla)
)

create table Aluno(
	Ra int not null,
	Cpf char(11) not null,
	Nome varchar(50) not null,
	Id_Curso int not null,
	constraint PK_ra primary key (Ra),
	constraint FK_Id_Curso foreign key(Id_Curso) references Curso(Id_Curso)
);

create table Professor(
	Id_Professor int not null identity(1,1),
	Cpf char(11) not null,
	Nome varchar(50) not null,
	constraint PK_Id_Professor primary key(Id_Professor),
	constraint UniqueProfessor unique (cpf)
)

create table Curso_Professor(
	Id_Professor int not null,
	Id_Curso int not null,
	constraint FK_Id_Professor foreign key(Id_Professor) references Professor(Id_Professor),
	constraint FK_Id_Curso_Professor foreign key(Id_Curso) references Curso(Id_Curso),
	constraint PK_Curso_Professor primary key(Id_Professor, Id_Curso)
)

create table Disciplina(
	Id_Disciplina int not null identity(1,1),
	Nome varchar(50) not null,
	Sigla varchar(10) not null,
	Carga_Horaria float not null,
	Id_Curso int not null,
	constraint PK_Id_Disciplina primary key(Id_disciplina),
	constraint FK_Id_Curso_Disciplina foreign key(Id_Curso) references Curso(Id_Curso)
)

create table Disciplina_Professor(
	Id_Disciplina int not null,
	Id_Professor int not null,
	Ano int not null,
	Semestre int not null,
	constraint PK_Disciplina_Professor primary key(Id_Disciplina, Id_Professor, Ano, Semestre),
	constraint FK_Id_Disciplina foreign key(Id_Disciplina) references Disciplina(Id_Disciplina),
	constraint FK_Id_Professor_DP foreign key(Id_Professor) references Professor(Id_Professor)
)

create table Matricula(
	Id_Disciplina int not null,
	Ra int not null,
	Ano int not null,
	Semestre int not null,
	Faltas int not null,
	Sub float default 0,
	Media float,
	Prova1 float not null,
	Prova2 float not null,
	Situacao varchar(50),
	constraint FK_Id_Disciplina_Matricula foreign key(Id_Disciplina) references Disciplina(Id_Disciplina),
	constraint FK_Ra foreign key(Ra) references Aluno(Ra),
	constraint PK_Matricula primary key(Id_Disciplina, Ra, Ano, Semestre)
)
go
drop trigger TMatricula 
go
Create trigger TMatricula 
on Matricula
for insert
as
begin
	declare
	@p1 float,
	@p2 float,
	@ra int,
	@dic smallint,
	@sub decimal(3,1),
	@falta smallint,
	@cargah smallint
	select @p1 = i.Prova1, @p2 = i.Prova2, @ra = i.RA, @dic = i.Id_Disciplina, @sub = i.Sub, @falta = i.Faltas, @cargah = d.Carga_horaria
	from inserted i, Disciplina d
	where d.Id_Disciplina  = i.Id_Disciplina
	set @falta = ((@cargah - @falta) * 100) / @cargah;
	update Matricula set 
	Matricula.Media = case when (@p1 + @p2)/2 < 6 then
	case when @p2>@p1 then (@sub + @p2)/2  else (@sub + @p1)/2 end
	else (@p1 + @p2)/2 end
	where Id_Disciplina = @dic and RA = @ra;
	update Matricula set
	Matricula.Situacao = case when Media < 6 then 'Reprovado por Nota' 
	when @falta < 75 then 'Reprovado por Falta'
	else 'Aprovado' end
	where  Id_Disciplina = @dic and RA = @ra;
end

insert into Professor values('94028592048','Pestana')
insert into Professor values('45680125673','Papini')
select * from Professor


insert into Curso values ('Engenharia de Computação', 'EC')
insert into Curso values ('Sistemas da Informação', 'SI')
insert into Curso values ('Direito', 'DTO')
insert into Curso values ('Odontologia', 'ODT')
select * from Curso


insert into Disciplina values ('Estrutura de Dados', 'ED', 50, 1)
insert into Disciplina values ('Banco de Dados', 'BD', 20,2)
insert into Disciplina values ('Estrutura de Dados', 'ED', 45, 2)
insert into Disciplina values ('Ética', 'ET', 30, 3)
insert into Disciplina values ('Ciência Política', 'CP', 80, 3)
insert into Disciplina values ('Filosofio', 'FL', 10, 3)
insert into Disciplina values ('Cárie', 'CE', 100, 4)
select * from Disciplina


insert into Aluno values (64234,'9382638593', 'Hugo', 4)
insert into Aluno values (96346,'637578392', 'Gabriel', 3)
insert into Aluno values (73657,'463292847', 'Leo', 2)
insert into Aluno values (12345,'8476453682', 'Irwing', 1)
select * from Aluno


insert into Disciplina_Professor values (1, 1, 2020, 1)
insert into Disciplina_Professor values (1, 1, 2020, 2)
insert into Disciplina_Professor values (1, 1, 2021, 1)
insert into Disciplina_Professor values (2, 1, 2020, 1)
insert into Disciplina_Professor values (2, 1, 2020, 2)
insert into Disciplina_Professor values (2, 1, 2021, 1)
insert into Disciplina_Professor values (3, 1, 2020, 1)
insert into Disciplina_Professor values (3, 1, 2020, 2)
insert into Disciplina_Professor values (3, 1, 2021, 1)
insert into Disciplina_Professor values (7,2, 2020, 1)
insert into Disciplina_Professor values (7,2, 2020, 2)
insert into Disciplina_Professor values (7,2, 2021, 1)
select * from Disciplina_Professor

insert into Curso_Professor values(1, 1)
insert into Curso_Professor values(1, 2)
insert into Curso_Professor values(2, 4)
select * from Curso_Professor

insert into Matricula(Id_Disciplina, Ra, Ano, Semestre, Faltas, Sub, Prova1, Prova2) values (2, 64234, 2020, 1, 3, 5, 2, 8)
insert into Matricula(Id_Disciplina, Ra, Ano, Semestre, Faltas, Prova1, Prova2) values (3, 64234, 2020, 1, 13, 9, 8) 
insert into Matricula(Id_Disciplina, Ra, Ano, Semestre, Faltas, Prova1, Prova2) values (1, 96346, 2021, 1, 1, 3, 3)
insert into Matricula(Id_Disciplina, Ra, Ano, Semestre, Faltas, Prova1, Prova2) values (7, 12345, 2020, 2, 15, 10,10) 
select * from Matricula


SELECT A.Ra, A.Nome, D.Nome 
FROM Aluno A
JOIN Disciplina D on A.Id_Curso = D.Id_Curso
JOIN Disciplina_Professor DP on D.Id_Disciplina = DP.Id_Disciplina
WHERE DP.Ano = 2020 AND D.Sigla = 'BD'

SELECT A.Ra, A.Nome as "Aluno", D.Nome as "Disciplina", DP.Ano, DP.Semestre, M.Prova1, M.Prova2 
FROM Matricula M
JOIN Aluno A on A.Ra = M.Ra
JOIN Disciplina D on D.Id_Disciplina = M.Id_Disciplina
JOIN Disciplina_Professor DP on DP.Id_Disciplina = m.Id_Disciplina
WHERE DP.Ano = 2020 AND A.Nome = 'Irwing'

SELECT A.Ra, A.Nome as "Aluno", D.Nome as "Disciplina", DP.Semestre, M.Media, M.Situacao
FROM Aluno A
JOIN Matricula M on M.Ra = A.Ra
JOIN Disciplina D on D.Id_Disciplina = M.Id_Disciplina
JOIN Disciplina_Professor DP on DP.Id_Disciplina = m.Id_Disciplina
JOIN Professor P on P.Id_Professor = DP.Id_Professor
JOIN Curso_Professor CP on CP.Id_Professor = P.Id_Professor
JOIN Curso C on C.Id_Curso = CP.Id_Curso
WHERE DP.Ano = 2020 AND C.Sigla = 'SI' AND M.Media < 6 AND M.Situacao like '%nota'

SELECT A.Ra, A.Nome as "Aluno", C.Nome, D.Nome as "Disciplina", P.Nome as "Professor" ,DP.Ano, DP.Semestre, M.Media, M.Situacao
FROM Aluno A
JOIN Matricula M on M.Ra = A.Ra
JOIN Disciplina D on D.Id_Disciplina = M.Id_Disciplina
JOIN Disciplina_Professor DP on DP.Id_Disciplina = m.Id_Disciplina
JOIN Professor P on P.Id_Professor = DP.Id_Professor
JOIN Curso_Professor CP on CP.Id_Professor = P.Id_Professor
JOIN Curso C on C.Id_Curso = CP.Id_Curso
WHERE M.Media >= 6 AND M.Situacao like 'Aprovado'
ORDER BY C.Nome