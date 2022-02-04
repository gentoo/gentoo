# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module pam

DESCRIPTION="Tool for managing Linux filesystem encryption"
HOMEPAGE="https://github.com/google/fscrypt"

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/client9/misspell v0.3.4"
	"github.com/client9/misspell v0.3.4/go.mod"
	"github.com/golang/protobuf v1.2.0"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/google/renameio v0.1.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/rogpeppe/go-internal v1.3.0/go.mod"
	"github.com/urfave/cli v1.20.0"
	"github.com/urfave/cli v1.20.0/go.mod"
	"github.com/wadey/gocovmerge v0.0.0-20160331181800-b5bfa59ec0ad"
	"github.com/wadey/gocovmerge v0.0.0-20160331181800-b5bfa59ec0ad/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de"
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de/go.mod"
	"golang.org/x/mod v0.0.0-20190513183733-4bf6d317e70e/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20191127021746-63cb32ae39b2"
	"golang.org/x/sys v0.0.0-20191127021746-63cb32ae39b2/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
	"golang.org/x/tools v0.0.0-20190621195816-6e04913cbbac/go.mod"
	"golang.org/x/tools v0.0.0-20191025023517-2077df36852e"
	"golang.org/x/tools v0.0.0-20191025023517-2077df36852e/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/errgo.v2 v2.1.0/go.mod"
	"honnef.co/go/tools v0.0.1-2019.2.3"
	"honnef.co/go/tools v0.0.1-2019.2.3/go.mod"
)
go-module_set_globals

SRC_URI="
	https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}
"

# Apache-2.0: fscrypt, google/renameio
# BSD: golang/protobuf, rogpeppe/go-internal, golang/x/*
# BSD-2: pkg/errors
# MIT: BurntSushi/toml, kisielk/gotool, kr/*, urfave/cli, honnef.co/go/tools
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Remove-TestLoadSourceDevice.patch"
	"${FILESDIR}/0001-Makefile-Optionally-avoid-installation-of-Ubuntu-spe.patch"
)

src_compile() {
	# Set GO_LINK_FLAGS to the empty string, as fscrypt strips the
	# binary by default. See bug #783780.
	emake GO_LINK_FLAGS=""
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		PREFIX="/usr" \
		PAM_MODULE_DIR="$(getpam_mod_dir)" \
		PAM_CONFIG_DIR= \
		install
	einstalldocs

	newpamd "${FILESDIR}/fscrypt.pam-config" fscrypt
}
