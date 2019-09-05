# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,xml"
inherit autotools desktop flag-o-matic git-r3 python-single-r1 toolchain-funcs user

MY_P=${P/_beta/BETA}

DESCRIPTION="A utility for network discovery and security auditing"
HOMEPAGE="https://nmap.org/"

EGIT_REPO_URI="https://github.com/nmap/nmap"
SRC_URI="https://dev.gentoo.org/~jer/nmap-logo-64.png"

LICENSE="GPL-2"
SLOT="0"

IUSE="
	ipv6 libressl libssh2 ncat ndiff nls nmap-update nping +nse ssl system-lua
	zenmap
"
NMAP_LINGUAS=( de fr hi hr it ja pl pt_BR ru zh )
REQUIRED_USE="
	system-lua? ( nse )
	ndiff? ( ${PYTHON_REQUIRED_USE} )
	zenmap? ( ${PYTHON_REQUIRED_USE} )
"
RDEPEND="
	dev-libs/liblinear:=
	dev-libs/libpcre
	net-libs/libpcap
	libssh2? (
		net-libs/libssh2[zlib]
		sys-libs/zlib
	)
	ndiff? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	nmap-update? (
		dev-libs/apr
		dev-vcs/subversion
	)
	nse? ( sys-libs/zlib )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	system-lua? ( >=dev-lang/lua-5.2:*[deprecated] )
	zenmap? (
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"
PATCHES=(
	"${FILESDIR}"/${PN}-5.10_beta1-string.patch
	"${FILESDIR}"/${PN}-5.21-python.patch
	"${FILESDIR}"/${PN}-6.46-uninstaller.patch
	"${FILESDIR}"/${PN}-6.25-liblua-ar.patch
	"${FILESDIR}"/${PN}-7.25-no-FORTIFY_SOURCE.patch
	"${FILESDIR}"/${PN}-7.25-CXXFLAGS.patch
	"${FILESDIR}"/${PN}-7.25-libpcre.patch
	"${FILESDIR}"/${PN}-7.31-libnl.patch
	"${FILESDIR}"/${PN}-7.80-ac-config-subdirs.patch
)
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use ndiff || use zenmap; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	rm -r liblinear/ libpcap/ libpcre/ libssh2/ libz/ || die

	cat "${FILESDIR}"/nls.m4 >> "${S}"/acinclude.m4 || die

	default

	local lingua
	if use nls; then
		for lingua in ${NMAP_LINGUAS[@]}; do
			if ! has ${lingua} ${LINGUAS-${lingua}}; then
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
		-e 's|^Categories=.*|Categories=Network;System;Security;|g' \
		zenmap/install_scripts/unix/zenmap-root.desktop \
		zenmap/install_scripts/unix/zenmap.desktop || die

	cp libdnet-stripped/include/config.h.in{,.nmap-orig} || die

	eautoreconf

	if [[ ${CHOST} == *-darwin* ]] ; then
		# we need the original for a Darwin-specific fix, bug #604432
		mv libdnet-stripped/include/config.h.in{.nmap-orig,} || die
	fi
}

src_configure() {
	# The bundled libdnet is incompatible with the version available in the
	# tree, so we cannot use the system library here.
	econf \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_with libssh2) \
		$(use_with ncat) \
		$(use_with ndiff) \
		$(use_with nmap-update) \
		$(use_with nping) \
		$(use_with ssl openssl) \
		$(use_with zenmap) \
		$(usex libssh2 --with-zlib) \
		$(usex nse --with-zlib) \
		$(usex nse --with-liblua=$(usex system-lua /usr included '' '') --without-liblua) \
		--cache-file="${S}"/config.cache \
		--with-libdnet=included \
		--with-pcre=/usr
	#	Commented out because configure does weird things
	#	--with-liblinear=/usr \
}

src_compile() {
	local directory
	for directory in . libnetutil nsock/src \
		$(usex ncat ncat '') \
		$(usex nmap-update nmap-update '') \
		$(usex nping nping '')
	do
		emake -C "${directory}" makefile.dep
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
