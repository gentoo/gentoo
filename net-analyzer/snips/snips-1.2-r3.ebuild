# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snips/snips-1.2-r3.ebuild,v 1.2 2013/04/16 11:55:13 ulm Exp $

EAPI=4

inherit base toolchain-funcs user

DESCRIPTION="System & Network Integrated Polling Software"
HOMEPAGE="http://www.netplex-tech.com/snips/"
SRC_URI="http://www.netplex-tech.com/software/downloads/${PN}/${P}.tar.gz"

LICENSE="SNIPS BSD HPND GPL-1+ RSA free-noncomm"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/perl
	 virtual/mailx
	 net-analyzer/rrdtool
	 >=net-misc/iputils-20071127-r2
	 sys-libs/gdbm
	 sys-libs/ncurses"

PATCHES=(
	"${FILESDIR}/${P}-ldflags-respect.patch"
	"${FILESDIR}/${P}-parallel-make.patch"
	"${FILESDIR}/${P}-non-interactive.patch"
	"${FILESDIR}/${P}-install-missing.patch"
	"${FILESDIR}/${P}-implicit-declarations.patch"
	"${FILESDIR}/${P}-conflicting-types.patch"
	"${FILESDIR}/${P}-code-ordering.patch"
	"${FILESDIR}/${P}-destdir-awareness.patch"
	"${FILESDIR}/${P}-trapmon-link-order.patch"
	"${FILESDIR}/${P}-nsmon-libresolv.patch"
	"${FILESDIR}/${P}-etherload-makefile-ordering.patch"
	"${FILESDIR}/${P}-linux3.patch"
)

src_prepare() {
	# Gentoo-specific non-interactive configure override
	cp "${FILESDIR}/${P}-r2-precache-config" "${S}/Config.cache" \
		|| die "Unable to precache configure script answers"
	echo "CFLAGS=\"${CFLAGS} -fPIC\"" >> "${S}/Config.cache"
	echo "CC=\"$(tc-getCC)\"" >> "${S}/Config.cache"
	echo "SRCDIR=\"${S}\"" >> "${S}/Config.cache"
	base_src_prepare
}

src_compile() {
	# Looks horrid due to missing linebreaks, suppress output
	ebegin "Running configure script (with precached settings)"
		./Configure &> /dev/null || die "Unable to configure"
	eend $?
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_preinst() {
	enewgroup snips
	enewuser snips -1 -1 /usr/snips snips
}

pkg_postinst() {
	ebegin "Fixing permissions"
	chown -R snips:snips "${ROOT}"usr/snips
	for x in data logs msgs rrddata run web device-help etc; do
		chmod -R g+w "${ROOT}usr/snips/${x}" \
			|| die "Unable to chmod ${x}"
	done
	chown root:snips "${ROOT}usr/snips/bin/multiping" || die "chown root failed"
	chown root:snips "${ROOT}usr/snips/bin/etherload" || die "chown root failed"
	chown root:snips "${ROOT}usr/snips/bin/trapmon" || die "chown root failed"
	chmod u+s "${ROOT}usr/snips/bin/multiping" || die "SetUID root failed"
	chmod u+s "${ROOT}usr/snips/bin/etherload" || die "SetUID root failed"
	chmod u+s "${ROOT}usr/snips/bin/trapmon" || die "SetUID root failed"
	eend $?
}
