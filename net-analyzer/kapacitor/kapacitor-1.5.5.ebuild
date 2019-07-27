# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/influxdata/kapacitor
EGIT_COMMIT="71a67c40348a8dfdad3f76d4c699ff8ef938da2b"
EGIT_BRANCH="master"

inherit golang-build golang-vcs-snapshot systemd user bash-completion-r1

DESCRIPTION="Monitoring, processing and alerting on time series data"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT BSD Apache-2.0 BSD-2 ISC MPL-2.0 EPL-1.0 LGPL-3-with-linking-exception"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

pkg_setup() {
	enewgroup kapacitor
	enewuser kapacitor -1 -1 /var/lib/kapacitor kapacitor
}

# Staticaly linked dependencies (already vendored):
# gopkg.in/fsnotify.v1	# BSD
# gopkg.in/gomail.v2	# MIT
# gopkg.in/inf.v0	# BSD
# gopkg.in/yaml.v2	# Apache-2.0, MIT
# golang.org/x/crypto	# BSD
# golang.org/x/oauth2	# BSD
# golang.org/x/net	# BSD
# golang.org/x/sys	# BSD
# golang.org/x/text	# BSD
# github.com/golang/glog	# Apache-2.0
# github.com/golang/snappy	# BSD
# github.com/pkg/errors	# BSD-2
# github.com/golang/protobuf	# BSD
# github.com/influxdata/influxdb	# MIT
# github.com/influxdata/usage-client	# MIT
# github.com/go-openapi/jsonpointer	# Apache-2.0
# github.com/go-openapi/jsonreference	# Apache-2.0
# github.com/go-openapi/spec	# Apache-2.0
# github.com/go-openapi/swag	# Apache-2.0
# github.com/prometheus/client_golang	# Apache-2.0
# github.com/prometheus/client_model	# Apache-2.0
# github.com/prometheus/common	# Apache-2.0
# github.com/prometheus/procfs	# Apache-2.0
# github.com/prometheus/prometheus	# Apache-2.0
# cloud.google.com/go	# Apache-2.0
# google.golang.org/api	# BSD
# google.golang.org/grpc	# BSD
# github.com/google/uuid	# BSD
# github.com/google/gofuzz	# Apache-2.0
# github.com/googleapis/gax-go	# BSD
# github.com/docker/docker	# Apache-2.0
# github.com/docker/distribution	# Apache-2.0
# github.com/docker/go-connections	# Apache-2.0
# github.com/docker/go-units	# Apache-2.0
# github.com/hashicorp/consul	# MPL-2.0
# github.com/hashicorp/go-cleanhttp	# MPL-2.0
# github.com/hashicorp/go-rootcerts	# MPL-2.0
# github.com/hashicorp/serf	# MPL-2.0
# github.com/coreos/go-oidc	# Apache-2.0
# github.com/coreos/pkg	# Apache-2.0
# github.com/pborman/uuid	# BSD
# github.com/Azure/azure-sdk-for-go	# Apache-2.0
# github.com/BurntSushi/toml	# MIT
# github.com/aws/aws-sdk-go	# Apache-2.0
# github.com/boltdb/bolt	# MIT
# github.com/cenkalti/backoff   # MIT
# github.com/dgrijalva/jwt-go	# MIT
# github.com/dustin/go-humanize	# MIT
# github.com/serenize/snaker	# MIT
# github.com/russross/blackfriday	# BSD-2
# github.com/mattn/go-runewidth	# MIT
# github.com/eclipse/paho.mqtt.golang	# EPL-1.0
# github.com/ghodss/yaml	# BSD
# github.com/go-ini/ini		# Apache-2.0
# github.com/mailru/easyjson	# MIT
# github.com/evanphx/json-patch # BSD
# github.com/mitchellh/copystructure	#  MIT
# github.com/gogo/protobuf	# BSD
# github.com/matttproud/golang_protobuf_extensions	# Apache-2.0
# github.com/jmespath/go-jmespath	# Apache-2.0
# github.com/shurcooL/sanitized_anchor_name	# MIT
# github.com/k-sone/snmpgo	# MIT
# github.com/mitchellh/mapstructure	# MIT
# github.com/segmentio/kafka-go	# MIT
# github.com/Azure/go-autorest	# Apache-2.0
# github.com/miekg/dns	# BSD
# github.com/geoffgarside/ber	# BSD
# github.com/beorn7/perks	# MIT
# github.com/Sirupsen/logrus	# MIT
# github.com/davecgh/go-spew	# ISC
# github.com/emicklei/go-restful	# MIT
# github.com/juju/ratelimit	# LGPL-3-with-linking-exception
# github.com/blang/semver	# MIT
# github.com/jonboulle/clockwork	# Apache-2.0
# github.com/kimor79/gollectd	# BSD
# github.com/mitchellh/reflectwalk	# MIT
# github.com/samuel/go-zookeeper	# BSD
# github.com/spf13/pflag	# BSD
# github.com/syndtr/goleveldb	# BSD-2
# github.com/PuerkitoBio/purell	# BSD
# github.com/PuerkitoBio/urlesc	# BSD
# github.com/ugorji/go	# MIT
# k8s.io/client-go	# Apache-2.0

src_unpack() {
	golang-vcs-snapshot_src_unpack

	use test && return

	# we are going to remove some stuff that is not required for compoilation
	# but may have some license issues
	local unneeded_dir
	local unneeded_dirs=(
		github.com/BurntSushi/toml/cmd/toml-test-decoder
		github.com/BurntSushi/toml/cmd/toml-test-encoder
		github.com/BurntSushi/toml/cmd/tomlv
		github.com/docker/docker/contrib
		github.com/hashicorp/consul/website
		github.com/hashicorp/serf/website
		github.com/benbjohnson/tmpl
		github.com/google/go-cmp
		github.com/influxdata/wlog
		github.com/mitchellh/go-homedir
		github.com/pmezard/go-difflib
		github.com/stretchr/testify
		google.golang.org/appengine
		gopkg.in/alexcesaro/quotedprintable.v3
	)
	for unneeded_dir in ${unneeded_dirs[@]}; do
		rm -vrf "${S}/src/${EGO_PN}/vendor/${unneeded_dir}" || die "can't remove ${unneeded_dir}"
	done
}

src_compile() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go install -v -work \
		-ldflags="-X main.version=v${PV} -X main.commit=${EGIT_COMMIT} -X main.branch=${EGIT_BRANCH} -X main.platform=OSS" \
		-x ./...
	echo "$@"
	"$@" || die "compile failed"
	popd > /dev/null
}

src_install() {
	pushd "src/${EGO_PN}" > /dev/null || die
	dobin "${S}"/bin/kapacitor{,d}
	insinto /etc/kapacitor
	doins etc/kapacitor/kapacitor.conf
	keepdir /etc/kapacitor/load
	insinto /etc/logrotate.d
	doins etc/logrotate.d/kapacitor
	systemd_dounit scripts/kapacitor.service
	keepdir /var/log/kapacitor
	fowners kapacitor:kapacitor /var/log/kapacitor
	newconfd "${FILESDIR}"/kapacitor.confd kapacitor
	newinitd "${FILESDIR}"/kapacitor.rc-r1 kapacitor

	newbashcomp usr/share/bash-completion/completions/kapacitor "${PN}" || die

	dodoc -r examples/ && dodoc *.md

	popd > /dev/null || die
}
