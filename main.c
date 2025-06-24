#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct s_list
{
  void *data;
  struct s_list *next;
} t_list;

int *create_data_elem (int data);
t_list *create_elem (int data);
static void push_front (t_list **lst_ptr, t_list *new_front);
static t_list *reverse (t_list *list);
t_list *list_from_format (char *fmt);

extern size_t ft_strlen (const char *str);
extern char *ft_strcpy (char *dst, const char *src);
extern int ft_strcmp (const char *s1, const char *s2);
extern ssize_t ft_write (int fd, const void *buf, size_t count);
extern ssize_t ft_read (int fd, const void *buf, size_t count);
extern char *ft_strdup (const char *s);
extern int ft_atoi_base (char *str, char *base);
extern void ft_list_sort (t_list **begin, int (*cmp) ());

static int
compar_int (void *a, void *b)
{
  int num1 = *(int *)a;
  int num2 = *(int *)b;
  return num1 - num2;
}

int
main ()
{
  char *str = "Hello, World!";
  char *str2 = "";
  char *str3 = "Eduardo";
  printf ("Testes do ft_strlen: \n");
  printf ("Hello, World! | %ld | %ld\n", ft_strlen (str), strlen (str));
  printf ("Vazio | %ld | %ld \n", ft_strlen (str2), strlen (str2));
  printf ("--------------------------------\n");
  char cpystr[8] = { '\0' };
  char *str5 = strcpy (cpystr, str3);
  printf ("System strcpy, %s, buffer %s\n", str5, cpystr);
  char cpystr2[8] = { '\0' };
  char *str6 = ft_strcpy (cpystr2, str3);
  printf ("Our ft_strcpy, %s, buffer %s\n", str6, cpystr2);
  printf ("--------------------------------\n");
  char *strcp = "abcdef123";
  char *strcp2 = "abcdef124";
  char *strcp3 = "abcdef121";
  char *strcp4 = "abcefd123";
  char *strcp5 = "bbcefd123";
  printf ("strcmp return value and ours: %d | %d\n", strcmp (strcp, strcp2),
          ft_strcmp (strcp, strcp2));
  printf ("strcmp return value and ours: %d | %d\n", strcmp (strcp, strcp3),
          ft_strcmp (strcp, strcp3));
  printf ("strcmp return value and ours: %d | %d\n", strcmp (strcp, strcp4),
          ft_strcmp (strcp, strcp4));
  printf ("strcmp return value and ours: %d | %d\n", strcmp (strcp, strcp4),
          ft_strcmp (strcp, strcp4));
  printf ("strcmp return value and ours: %d | %d\n", strcmp (strcp4, strcp5),
          ft_strcmp (strcp4, strcp5));

  char *p = ft_strdup (strcp);

  if (p != NULL)
    {
      printf ("P IS VALID!!!\n");
      printf ("%s | %s\n", strcp, p);
      free (p);
    }
  else
    {
      printf ("P IS NULL!!!\n");
      printf ("Value of errno: %d\n", errno);
      printf ("The error message 1 is : %s\n", strerror (errno));
    }

  int fd = open ("test_file.txt", O_RDWR | O_APPEND);
  ssize_t a = write (1, "Hello, World!\n", 14);
  ssize_t b = write (fd, "Our Hello from x86-64 Assembly Code\n", 36);
  ssize_t c = ft_write (1, "Hello, World!\n", 14);
  printf ("Value of errno: %d\n", errno);
  printf ("The error message 1 is : %s\n", strerror (errno));
  ssize_t d = ft_write (fd, "Our Hello from x86-64 Assembly Code\n", 36);
  printf ("a, b, c, d | %ld | %ld | %ld | %ld \n", a, b, c, d);
  lseek (fd, 0, SEEK_SET);
  char buffer[15];
  char buffer2[15];
  ssize_t ret2 = read (fd, buffer, 15);
  if (ret2 > 0)
    buffer[14] = '\0';
  else
    buffer[0] = '\0';
  printf ("Value of errno: %d\n", errno);
  printf ("The error message 1 is : %s\n", strerror (errno));
  lseek (fd, 0, SEEK_SET);

  ssize_t ret = ft_read (fd, buffer2, 15);
  if (ret > 0)
    buffer2[14] = '\0';
  else
    buffer2[0] = '\0';

  printf ("Value of errno 2: %d\n", errno);
  printf ("The error message 2 is : %s\n", strerror (errno));
  printf ("Buffer1:\n%s\nBuffer2:\n%s\n| %ld | %ld\n", buffer, buffer2, ret2,
          ret);

  int b10 = ft_atoi_base ("f", "0123456789");
  int b2 = ft_atoi_base ("101", "01");
  int b16 = ft_atoi_base ("-++++++-+--ff", "0123456789abcdef");
  printf ("%d\n%d\n%d\n", b2, b10, b16);
  t_list *tmp = list_from_format ("1 2 3");
  ft_list_sort (&tmp, compar_int);
  t_list *walk = tmp;
  while (walk)
    {
      printf ("%i\n", *((int *)walk->data));
      walk = walk->next;
    }
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

// vim: sts=4 sw=4 et
