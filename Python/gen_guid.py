import random

def get_random_valid_char():
    if random.randint(0, 1):
        return str(random.randint(0, 9))
    else:
        return chr(random.randint(ord('a'),ord('f')))

chars = ''
for i in range(32):
    chars += get_random_valid_char()

guid = f'{{{chars[:8]}-{chars[8:12]}-{chars[12:16]}-{chars[16:20]}-{chars[20:]}}}'
print(guid)