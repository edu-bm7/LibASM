#include "libasm.h"

static int
compar_int (void *a, void *b)
{
  int num1 = *(int *)a;
  int num2 = *(int *)b;
  return num1 - num2;
}

static void
free_fct (void *data)
{
  free (data);
}

void
ft_list_remove_if_in_c (t_list **begin, void *data_ref,
                        int (*cmp) (void *, void *), void (*free_fct) (void *))
{
  t_list **link = begin;
  while (*link)
    {
      t_list *node = *link;
      if (!cmp (node->data, data_ref))
        {
          *link = node->next;
          free_fct (node->data);
          free (node);
        }
      else
        {
          link = &node->next;
        }
    }
}

void
list_destroy (t_list *list)
{
  if (list == NULL)
    return;
  list_destroy (list->next);
  if (list->data != NULL)
    free (list->data);
  free (list);
}

int
main ()
{
  char *str = "Hello, World!";
  char *str2 = "";
  char *str3 = "Eduardo";
  printf (
      "--------------------- ft_strlen-------------------------------- \n");
  printf ("Hello, World! | %ld | %ld\n", ft_strlen (str), strlen (str));
  printf ("Vazio | %ld | %ld \n", ft_strlen (str2), strlen (str2));
  printf (
      "----------------------------------------------------------------\n");
  char cpystr[8] = { '\0' };
  char *str5 = strcpy (cpystr, str3);
  printf (
      "--------------------- ft_strcpy-------------------------------- \n");
  printf ("System strcpy, %s, buffer %s\n", str5, cpystr);

  char cpystr2[8] = { '\0' };
  char *str6 = ft_strcpy (cpystr2, str3);

  printf ("ft_strcpy, %s, buffer %s\n", str6, cpystr2);
  printf (
      "----------------------------------------------------------------\n");
  printf (
      "--------------------- ft_strcmp-------------------------------- \n");

  char *strcp = "abcdef123";
  char *strcp2 = "abcdef124";
  char *strcp3 = "abcdef121";
  char *strcp4 = "abcefd123";
  char *strcp5 = "bbcefd123";

  printf ("SYSTEM STRCMP | FT_STRCMP: ('abcdef123','abcdef124') \n%d | %d\n",
          strcmp (strcp, strcp2), ft_strcmp (strcp, strcp2));
  printf ("SYSTEM STRCMP | FT_STRCMP:('abcdef123','abcdef121' \n%d | %d\n",
          strcmp (strcp, strcp3), ft_strcmp (strcp, strcp3));
  printf ("SYSTEM STRCMP | FT_STRCMP: ('abcdef123','abcdef123')\n%d | %d\n",
          strcmp (strcp, strcp), ft_strcmp (strcp, strcp));
  printf ("SYSTEM STRCMP | FT_STRCMP: ('abcdef123','abcefd123')\n%d | %d\n",
          strcmp (strcp, strcp4), ft_strcmp (strcp, strcp4));
  printf ("SYSTEM STRCMP | FT_STRCMP: ('abcefd123','bbcefd123')\n %d | %d\n",
          strcmp (strcp4, strcp5), ft_strcmp (strcp4, strcp5));

  printf (
      "----------------------------------------------------------------\n");
  printf (
      "--------------------- ft_strdup-------------------------------- \n");

  char *p = ft_strdup (strcp);

  if (p != NULL)
    {
      printf ("Pointer IS VALID!!!\n");
      printf ("%s | %s\n", strcp, p);
      free (p);
    }
  else
    {
      printf ("Pointer IS NULL!!!\n");
      printf ("Value of errno: %d\n", errno);
      printf ("The error message 1 is : %s\n", strerror (errno));
    }
  printf (
      "------------------------------------------------------------------\n");
  printf (
      "--------------------- ft_write--------------------------------- \n");

  int fd = open ("test_file.txt", O_CREAT | O_RDWR | O_APPEND);
  printf ("System write: \n");
  ssize_t a = write (1, "Hello, World!\n", 14);
  printf ("ft_write(): \n");
  ssize_t c = ft_write (1, "Hello, World!\n", 14);
  printf ("System write to FD(test_file.txt): \n");
  ssize_t b = write (fd, "Our Hello from x86-64 Assembly Code\n", 36);
  printf ("ft_write() to FD(test_file.txt): \n");
  ssize_t d = ft_write (fd, "Our Hello from x86-64 Assembly Code\n", 36);
  printf ("system write | system write | ft_write | ft_write | %ld | %ld | "
          "%ld | %ld \n",
          a, b, c, d);
  printf ("testing ft_write errno support (writing to a bad FD): \n ");
  ft_write (1936, "Our Hello from x86-64 Assembly Code\n", 36);
  printf ("Value of our write errno: %d\n", errno);
  printf ("The error message 2 is : %s\n", strerror (errno));
  printf ("-------------------System read() ------------------------------\n");

  lseek (fd, 0, SEEK_SET);
  char buffer[15];
  char buffer2[15];
  ssize_t ret2 = read (fd, buffer, 15);
  if (ret2 > 0)
    buffer[14] = '\0';
  else
    buffer[0] = '\0';
  lseek (fd, 0, SEEK_SET);

  ssize_t ret = ft_read (fd, buffer2, 15);
  if (ret > 0)
    buffer2[14] = '\0';
  else
    buffer2[0] = '\0';

  printf ("Buffer1:\n%s\n", buffer);
  printf (
      "------------------------ft_read()-------------------------------\n");
  printf ("Buffer2:\n%s\nRETURN VALUE OF READ | %ld | %ld\n", buffer2, ret2,
          ret);
  printf (
      "----------------------ATOI BASE---------------------------------\n");

  int b2 = ft_atoi_base ("101", "01");
  int b10 = ft_atoi_base ("f", "0123456789");
  int b16 = ft_atoi_base ("-++++++-+--ff", "0123456789abcdef");

  printf ("%d\n%d\n%d\n", b2, b10, b16);
  printf (
      "------------------------ft_list_sort----------------------------\n");
  t_list *tmp = list_from_format ("-7 9 0 8 3 1 6 12 32 18");
  ft_list_sort (&tmp, compar_int);
  t_list *walk = tmp;
  while (walk)
    {
      printf ("%i ", *((int *)walk->data));
      walk = walk->next;
    }
  printf ("\n");

  list_destroy (tmp);
  printf ("---------------ft_list_size and "
          "ft_list_push_front------------------\n");
  tmp = list_from_format ("");
  printf ("List initial size: %i\n", ft_list_size (tmp));
  printf ("Calling ft_list_push_front(3)\n");
  ft_list_push_front (&tmp, create_data_elem (3));
  printf ("List size: %i\n", ft_list_size (tmp));
  printf ("Calling ft_list_push_front(2)\n");
  ft_list_push_front (&tmp, create_data_elem (2));
  printf ("List size: %i\n", ft_list_size (tmp));
  printf ("Calling ft_list_push_front(1)\n");
  ft_list_push_front (&tmp, create_data_elem (1));
  printf ("List size: %i\n", ft_list_size (tmp));
  printf ("List elements: \n");
  walk = tmp;
  while (walk)
    {
      printf ("%i ", *(int *)walk->data);
      walk = walk->next;
    }
  printf ("\n");
  list_destroy (tmp);
  printf ("-------------------ft_list_remove_if-------------------------------"
          "-\n");
  int i = 1;
  t_list *li = list_from_format ("1 1 1 1 1 1");
  printf ("Lista: 1 1 1 1 1 1\nChamando list_remove_if(1)...\n");
  ft_list_remove_if (&li, &i, compar_int, free_fct);
  if (li)
    {
      printf ("Não removeu todos os items!\n");
    }
  else
    {
      printf ("Removeu todos os items!\n");
    }
  printf ("List size depois do remove_if: %i\n", ft_list_size (li));
  list_destroy (li);
  printf ("Lista: 1 2 1 2 1 2\nChamando list_remove_if(1)...\n");
  li = list_from_format ("1 2 1 2 1 2");
  ft_list_remove_if (&li, &i, compar_int, free_fct);
  t_list *curr = li;
  int fail = 0;
  printf ("Lista depois do remove_if:\n");
  while (curr)
    {
      if (!compar_int (curr->data, &i))
        {
          fail = 1;
          break;
        }
      printf ("%d ", *(int *)curr->data);
      curr = curr->next;
    }
  printf ("\n");
  if (fail)
    {
      printf ("FALHOU!");
    }
  list_destroy (li);

  return 0;
}

int *
create_data_elem (int data)
{
  int *data_ptr = malloc (sizeof (int));
  if (data_ptr == NULL)
    return (NULL);
  *data_ptr = data;
  return data_ptr;
}

t_list *
create_elem (int data)
{
  t_list *new = malloc (sizeof (t_list));
  if (new == NULL)
    return NULL;
  if ((new->data = create_data_elem (data)) == NULL)
    return (NULL);
  new->next = NULL;
  return new;
}

static void
push_front (t_list **lst_ptr, t_list *new_front)
{
  if (lst_ptr == NULL || new_front == NULL)
    return;
  new_front->next = *lst_ptr;
  *lst_ptr = new_front;
}

static t_list *
reverse (t_list *list)
{
  if (list == NULL || list->next == NULL)
    return list;
  t_list *tmp = reverse (list->next);
  list->next->next = list;
  list->next = NULL;
  return tmp;
}

t_list *
list_from_format (char *fmt)
{
  t_list *head = NULL;

  while (fmt != NULL && *fmt)
    {
      int n = (int)strtol (fmt, &fmt, 10);
      t_list *elem = create_elem (n);
      push_front (&head, elem);
    }
  return reverse (head);
}
// vim: sts=2 sw=2 et
