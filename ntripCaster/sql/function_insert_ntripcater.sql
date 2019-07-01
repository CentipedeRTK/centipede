CREATE OR REPLACE FUNCTION public.ntripcaster()
  RETURNS TRIGGER AS
$BODY$
BEGIN
  COPY ( select type from centipede.ntripcaster union ALL (select '/'||mp from public.antenne order by mp)) TO '/home/ntripcaster.conf';
  RETURN NEW;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig_ntripcaster AFTER INSERT OR UPDATE OR DELETE
   ON public.antenne FOR EACH ROW
   EXECUTE PROCEDURE public.ntripcaster();
