VERSION=7.6.0-alpha1
REPO=menski
IMAGE=i-woke-up-like-this

SERVER=tomcat wildfly jboss
RUN=$(SERVER:=-run)
RUN_EE=$(SERVER:=-run-ee)
DAEMON=$(SERVER:=-daemon)
DAEMON_EE=$(SERVER:=-daemon-ee)

all: $(SERVER)

$(SERVER):
	./build.sh $(VERSION) $@

$(RUN): rmf
	docker run --rm --name camunda -p 8080:8080 $(REPO)/$(IMAGE):$(@:-run=)-$(VERSION)

$(RUN_EE): rmf
	docker run --rm --name camunda -p 8080:8080 $(REPO)/$(IMAGE):$(@:-run-ee=)-$(VERSION)-ee

$(DAEMON): rmf
	docker run -d --name camunda -p 8080:8080 $(REPO)/$(IMAGE):$(@:-daemon=)-$(VERSION)

$(DAEMON_EE): rmf
	docker run -d --name camunda -p 8080:8080 $(REPO)/$(IMAGE):$(@:-daemon-ee=)-$(VERSION)-ee

rmf:
	-docker rm -f -v camunda

logs:
	docker logs -f camunda

sh:
	docker exec -it camunda sh


.PHONY: $(SERVER) $(RUN) $(RUN_EE) $(DAEMON) $(DAEMON_EE) rmf logs sh
