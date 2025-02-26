/* History:23,5 */
#include <stdio.h>
#include <malloc.h>

#ifdef TEST_NEWARG

main(int argc, char **argv)
{
  int i;
  new_argc_argv(&argc, &argv);
  printf("argc = %d\n", argc);
  for (i=0; argv[i]; i++)
    printf("argv[%d] = %s\n", i, argv[i]);
}

#endif

struct ARG {
  struct ARG *next;
  char *this;
  } ARG;

new_argc_argv(int *argc, char ***argv)
{
  struct ARG *root = 0, *last;
  struct ARG *arg;
  char buf[1024];
  int i;
  FILE *f;
  for (i=0; (*argv)[i]; i++)
  {
    if ((*argv)[i][0] == '@')
    {
      f = fopen((*argv)[i]+1, "r");
      if (f == NULL)
        goto regular_arg;
      while (fscanf(f, "%s", buf) == 1)
      {
        arg = (struct ARG *)malloc(sizeof(struct ARG));
        arg->next = 0;
        arg->this = (char *)malloc(strlen(buf)+1);
        strcpy(arg->this, buf);
        if (!root)
          root = last = arg;
        else
        {
          last->next = arg;
          last = arg;
        }
      }
      fclose(f);
    }
    else
    {
regular_arg:
      arg = (struct ARG *)malloc(sizeof(struct ARG));
      arg->next = 0;
      arg->this = (*argv)[i];
      if (!root)
        root = last = arg;
      else
      {
        last->next = arg;
        last = arg;
      }
    }
  }
  for (*argc = 1, arg = root; arg; arg = arg->next)
    (*argc)++;
  *argv = (char **)malloc(*argc * sizeof(char *));
  for ((*argc) = 0, arg = root; arg; arg = arg->next)
    (*argv)[(*argc)++] = arg->this;
  while (root)
  {
    arg = root->next;
    free(root);
    root = arg;
  }
  (*argv)[*argc] = 0;
}
