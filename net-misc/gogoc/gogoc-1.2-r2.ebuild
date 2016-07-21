# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils versionator toolchain-funcs

MY_P=${PN}-$(replace_all_version_separators "_")
if [[ ${MY_P/_beta/} != ${MY_P} ]]; then
	MY_P=${MY_P/_beta/-BETA}
else
	MY_P=${MY_P}-RELEASE
fi

DESCRIPTION="Client to connect to a tunnel broker using the TSP protocol (freenet6 for example)"
HOMEPAGE="http://gogonet.gogo6.com/page/download-1"
SRC_URI="http://gogo6.com/downloads/${MY_P}.tar.gz"

# GPL-2 for Gentoo init script
LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa sparc x86"
IUSE="debug"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}
	sys-apps/iproute2
	>=sys-apps/net-tools-1.60_p20120127084908"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-overflow.patch
	epatch "${FILESDIR}"/${P}+gcc-4.6.patch

	# Make the makefile handle linking correctly
	find . -name Makefile -exec sed -i \
		-e 's:LDFLAGS:LDLIBS:g' \
		-e '/\$(LDLIBS)/s:-o:$(LDFLAGS) -o:' \
		{} + || die "multised failed"

	sed -i -e 's:/usr/local/etc/gogoc:/etc/gogoc:' \
		gogoc-tsp/platform/*/tsp_local.c \
		|| die "path sed failed"

	# Newer net-tools use /bin
	sed -i -e "/^\(route\|ifconfig\)=/s/sbin/bin/" \
		gogoc-tsp/template/linux.sh \
		|| die "net-tools sed failed"
}

src_configure() { :; }

src_compile() {
	# parallel make fails as inter-directory dependecies are missing.
	emake -j1 \
		AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getCXX)" \
		EXTRA_CFLAGS="${CFLAGS}" EXTRA_CXXFLAGS="${CXXFLAGS}" \
		$(use debug && echo DEBUG=1) \
		all target=linux

	emake -C gogoc-tsp/conf \
		PLATFORM=linux PLATFORM_DIR=../platform BIN_DIR=../bin \
		gogoc.conf.sample
}

src_install() {
	dodoc README

	cd "${S}"/gogoc-tsp
	dosbin bin/gogoc

	dodoc bin/gogoc.conf.sample

	exeinto /etc/gogoc/template
	doexe template/linux.sh

	newinitd "${FILESDIR}"/gogoc.rc gogoc

	doman man/{man5/gogoc.conf.5,man8/gogoc.8}
	keepdir /var/lib/gogoc

	diropts -m0700
	keepdir /etc/gogoc
}

pkg_postinst() {
	elog "You should create an /etc/gogoc/gogoc.conf file starting from"
	elog "the sample configuration in /usr/share/doc/${PF}/gogoc.conf.sample.*"
	elog ""
	elog "To add support for a TSP IPv6 connection at startup,"
	elog "remember to run:"
	elog "# rc-update add gogoc default"
}
