#ifndef LIBASM_H
#define LIBASM_H

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
extern void ft_list_push_front (t_list **begin_list, void *data);
extern int ft_list_size (t_list *begin_list);
extern void ft_list_sort (t_list **begin, int (*cmp) (void *, void *));
extern void ft_list_remove_if (t_list **begin, void *data_ref,
                               int (*cmp) (void *, void *),
                               void (*free_fct) (void *));

#endif // LIBASM_H
