DB_URL = postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

network:
	docker network create bank-network

postgres:
	docker run --name postgres15 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	 migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	 migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	 migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc:
	sqlc generate

sqlcWindows:
	docker run --rm -v ${pwd}:/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run ./cmd/main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go simple_bank/db/sqlc Store


.PHONY: postgres createdb dropdb migrateup migrateup1 sqlc sqlcWindows test server mock