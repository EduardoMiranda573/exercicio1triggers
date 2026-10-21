create table estoque (
id serial primary key,
nome_item varchar(20) not null,
quantidade int not null default 0
);
create or replace function fn_valida_estoque_minimo()
returns trigger as $$
begin
if NEW.quantidade < 0 THEN
 RAISE EXCEPTION 'Operação cancelada! O item "%" não pode ter estoque negativo (Tentativa: % unidade(s)).', 
            NEW.nome_item, NEW.quantidade;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valida_estoque
BEFORE INSERT OR UPDATE ON estoque
FOR EACH ROW
EXECUTE FUNCTION fn_valida_estoque_minimo();