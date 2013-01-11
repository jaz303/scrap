buffers: test.proto
	protoc --cpp_out=gen test.proto

test:
	g++ -pthread  -pthread -lprotobuf -lz -lpthread -o test test.cpp gen/test.pb.cc

clean:
	rm -rf gen/*

