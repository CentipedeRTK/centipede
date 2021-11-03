--Update tbl commune : modify all specials characters

update public.commune c
set nom = (select translate(
    nom,
    'âãäåÁÂÃÄÅèééêëÈÉÉÊËìíîïìÌÍÎÏÌóôõöÒÓÔÕÖùúûüÙÚÛÜ',
    'aaaaAAAAAeeeeeEEEEEiiiiiIIIIIooooOOOOOuuuuUUUU'
) from public.commune where id = c.id);
