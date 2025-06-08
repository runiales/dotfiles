# Migración:

1. Exportar clave privada:
	1. gpg --list-secret-keys
	2. gpg --export-secret-keys --armor --output priv.asc <key.id.del.comando.anterior>
2. Importar clave privada (tiene que haber un directorio .gnupg/private-keys-v1.d):
	1. gpg --import <pkey>
3. Este paso no sé si es necesario:
	1. gpg --edit-key <keyid> # trust # 5
