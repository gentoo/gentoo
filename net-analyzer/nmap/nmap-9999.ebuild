# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,xml"
inherit eutils flag-o-matic git-r3 python-single-r1 toolchain-funcs user

MY_P=${P/_beta/BETA}

DESCRIPTION="A utility for network discovery and security auditing"
HOMEPAGE="http://nmap.org/"

EGIT_REPO_URI="https://github.com/nmap/nmap"
SRC_URI="https://dev.gentoo.org/~jer/nmap-logo-64.png"

LICENSE="GPL-2"
SLOT="0"

IUSE="ipv6 libressl +nse system-lua ncat ndiff nls nmap-update nping ssl zenmap"
NMAP_LINGUAS=( de fr hr it ja pl pt_BR ru zh )
IUSE+=" ${NMAP_LINGUAS[@]/#/linguas_}"

REQUIRED_USE="
	system-lua? ( nse )
	ndiff? ( ${PYTHON_REQUIRED_USE} )
	zenmap? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-libs/liblinear:=
	dev-libs/libpcre
	|| ( >=net-libs/libpcap-1.8.0 <net-libs/libpcap-1.8.0[ipv6?] )
	zenmap? (
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	system-lua? ( >=dev-lang/lua-5.2[deprecated] )
	ndiff? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	nmap-update? ( dev-libs/apr dev-vcs/subversion )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use ndiff || use zenmap; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-4.75-nolua.patch \
		"${FILESDIR}"/${PN}-5.10_beta1-string.patch \
		"${FILESDIR}"/${PN}-5.21-python.patch \
		"${FILESDIR}"/${PN}-6.25-liblua-ar.patch \
		"${FILESDIR}"/${PN}-6.46-uninstaller.patch \
		"${FILESDIR}"/${PN}-6.47-no-libnl.patch \
		"${FILESDIR}"/${PN}-7.25-no-FORTIFY_SOURCE.patch

	if use nls; then
		local lingua=''
		for lingua in ${NMAP_LINGUAS[@]}; do
			if ! use linguas_${lingua}; then
				rm -r zenmap/share/zenmap/locale/${lingua} || die
				rm zenmap/share/zenmap/locale/${lingua}.po || die
			fi
		done
	else
		# configure/make ignores --disable-nls
		for lingua in ${NMAP_LINGUAS[@]}; do
			rm -r zenmap/share/zenmap/locale/${lingua} || die
			rm zenmap/share/zenmap/locale/${lingua}.po || die
		done
	fi

	sed -i \
		-e '/^ALL_LINGUAS =/{s|$| id|g;s|jp|ja|g}' \
		Makefile.in || die

	# Fix desktop files wrt bug #432714
	sed -i \
		-e '/^Encoding/d' \
		-e 's|^Categories=.*|Categories=Network;System;Security;|g' \
		zenmap/install_scripts/unix/zenmap-root.desktop \
		zenmap/install_scripts/unix/zenmap.desktop || die

	epatch_user
}

src_configure() {
	# The bundled libdnet is incompatible with the version available in the
	# tree, so we cannot use the system library here.
	econf \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_with zenmap) \
		$(usex nse --with-liblua=$(usex system-lua /usr included '' '') --without-liblua) \
		$(use_with ncat) \
		$(use_with ndiff) \
		$(use_with nmap-update) \
		$(use_with nping) \
		$(use_with ssl openssl) \
		--with-libdnet=included \
		--with-pcre=/usr
	#	--with-liblinear=/usr \
	#	Commented because configure does weird things, while autodetection works
}

src_compile() {
	local dep deps="build-dnet build-nbase build-nsock build-netutil"
	use system-lua || deps="build-lua ${deps}"

	for dep in ${deps}; do
		emake makefile.dep ${dep}
	done

	emake \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB)
}

src_install() {
	LC_ALL=C emake -j1 \
		DESTDIR="${D}" \
		STRIP=: \
		nmapdatadir="${EPREFIX}"/usr/share/nmap \
		install
	if use nmap-update;then
		LC_ALL=C emake -j1 \
			-C nmap-update \
			DESTDIR="${D}" \
			STRIP=: \
			nmapdatadir="${EPREFIX}"/usr/share/nmap \
			install
	fi

	dodoc CHANGELOG HACKING docs/README docs/*.txt

	if use zenmap; then
		doicon "${DISTDIR}/nmap-logo-64.png"
		python_optimize
	fi
}
