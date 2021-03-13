# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 systemd toolchain-funcs

COMMIT="591a7834dc9f1dff3d336d769a6561138a5befe7"
DESCRIPTION="An OpenPGP keyserver which is decentralized with highly reliable synchronization"
HOMEPAGE="https://github.com/SKS-Keyserver/sks-keyserver"
SRC_URI="https://github.com/SKS-Keyserver/sks-keyserver/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-keyserver-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="optimize test"
RESTRICT="!test? ( test )"

DOC_CONTENTS="To get sks running, first build the database,
start the database, import atleast one key, then
run a cleandb. See the sks man page for more information
Typical DB_CONFIG file and sksconf has been installed
in /var/lib/sks and can be used as templates by renaming
to remove the .typical extension. The DB_CONFIG file has
to be in place before doing the database build, or the BDB
environment has to be manually cleared from both KDB and PTree.
The same applies if you are upgrading to this version with an existing KDB/Ptree,
using another version of BDB than 4.8; you need to clear the environment
using e.g. db4.6_recover -h . and db4.6_checkpoint -1h . in both KDB and PTree
Additionally a sample web interface has been installed as
web.typical in /var/lib/sks that can be used by renaming it to web
Important: It is strongly recommended to set up SKS behind a
reverse proxy. Instructions on properly configuring SKS can be
found at https://bitbucket.org/skskeyserver/sks-keyserver/wiki/Peering"

RDEPEND="
	acct-user/sks
	acct-group/sks
	>=dev-lang/ocaml-4.0:=
	dev-ml/camlp4:=
	dev-ml/cryptokit:=
	dev-ml/num:=
	sys-libs/db:5.3
"
DEPEND="${RDEPEND}
	dev-ml/findlib"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6_p20200624-respect-CFLAGS-CXXFLAGS.patch"
	"${FILESDIR}/${PN}-1.1.6_p20200624-QA-fixups.patch"
)

QA_FLAGS_IGNORED=(
	/usr/bin/sks_add_mail
)

src_prepare() {
	cp Makefile.local.unused Makefile.local || die
	sed -i \
		-e "s:^BDBLIB=.*$:BDBLIB=-L/usr/$(get_libdir):g" \
		-e "s:^BDBINCLUDE=.*$:BDBINCLUDE=-I/usr/include/db5.3/:g" \
		-e "s:^LIBDB=.*$:LIBDB=-ldb-5.3:g" \
		-e "s:^PREFIX=.*$:PREFIX=${D}/usr:g" \
		-e "s:^MANDIR=.*$:MANDIR=${D}/usr/share/man:g" \
		Makefile.local || die
	sed -i \
		-e 's:/usr/sbin/sks:/usr/bin/sks:g' \
		sks_build.sh || die

	dosym sks_build.sh /usr/bin/sks_build.bc.sh
	default
}

src_compile() {
	tc-export CC CXX RANLIB

	emake dep
	# sks build fails with parallel build in module Bdb
	emake -j1 all
	if use optimize; then
		emake all.bc
	fi
}

src_test() {
	./sks unit_test || die
}

src_install() {
	if use optimize; then
		emake install.bc
		dosym sks.bc usr/bin/sks
		dosym sks_add_mail.bc usr/bin/sks_add_mail
	else
		emake install
	fi

	dodoc README.md

	newinitd "${FILESDIR}/sks-db.initd" sks-db
	newinitd "${FILESDIR}/sks-recon.initd" sks-recon
	newconfd "${FILESDIR}/sks.confd" sks
	systemd_dounit "${FILESDIR}"/sks-db.service
	systemd_dounit "${FILESDIR}"/sks-recon.service

	dodir "/var/lib/sks/web.typical"

	insinto /var/lib/sks
	fowners sks:sks /var/lib/sks

	newins sampleConfig/DB_CONFIG DB_CONFIG.typical
	newins sampleConfig/sksconf.typical sksconf.typical
	insinto /var/lib/sks/web.typical
	doins sampleWeb/HTML5/*

	keepdir /var/lib/sks
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		einfo "Note when upgrading from versions of SKS earlier than 1.1.4"
		einfo "The default values for pagesize settings have changed. To continue"
		einfo "using an existing DB without rebuilding, explicit settings have to be"
		einfo "added to the sksconf file."
		einfo "pagesize:       4"
		einfo "ptree_pagesize: 1"
	fi;
}
