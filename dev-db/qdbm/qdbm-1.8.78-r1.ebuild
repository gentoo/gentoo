# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/qdbm/qdbm-1.8.78-r1.ebuild,v 1.11 2013/09/02 12:51:12 hattya Exp $

EAPI="5"

inherit eutils java-pkg-opt-2 multilib

DESCRIPTION="Quick Database Manager"
HOMEPAGE="http://fallabs.com/qdbm/"
SRC_URI="http://fallabs.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="cxx debug java perl ruby zlib"

RDEPEND="java? ( >=virtual/jre-1.4 )
	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	java? ( >=virtual/jdk-1.4 )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-runpath.diff
	epatch "${FILESDIR}"/${PN}-perl-runpath-vendor.diff
	epatch "${FILESDIR}"/${PN}-ruby19.diff
	# apply flags
	sed -i "/^CFLAGS/s|$| ${CFLAGS}|" Makefile.in
	sed -i "/^OPTIMIZE/s|$| ${CFLAGS}|" perl/Makefile.in
	sed -i "/^CXXFLAGS/s|$| ${CXXFLAGS}|" plus/Makefile.in
	sed -i "/^JAVACFLAGS/s|$| ${JAVACFLAGS}|" java/Makefile.in
	# replace make -> $(MAKE)
	sed -i "s/make\( \|$\)/\$(MAKE)\1/g" \
		Makefile.in \
		{cgi,java,perl,plus,ruby}/Makefile.in
}

qdbm_api_for() {
	local u
	for u in cxx java perl ruby; do
		if ! use "${u}"; then
			continue
		fi
		if [ "${u}" = "cxx" ]; then
			u="plus"
		fi
		cd "${u}"
		case "${EBUILD_PHASE}" in
		configure)
			econf
			;;
		compile)
			emake
			;;
		test)
			emake -j1 check
			;;
		install)
			emake DESTDIR="${D}" MYDATADIR=/usr/share/doc/${P}/html install
		esac
		cd -
	done
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable zlib) \
		--enable-pthread \
		--enable-iconv
	qdbm_api_for # configure
}

src_compile() {
	emake
	qdbm_api_for # compile
}

src_test() {
	emake -j1 check
	qdbm_api_for # test
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog NEWS README THANKS
	dohtml -r doc/
	rm -rf "${ED}"/usr/share/${PN}

	qdbm_api_for # install

	if use java; then
		java-pkg_dojar "${ED}"/usr/$(get_libdir)/*.jar
		rm -f "${ED}"/usr/$(get_libdir)/*.jar
	fi
	if use perl; then
		rm -f "${ED}"/$(perl -V:installarchlib | cut -d\' -f2)/*.pod
		find "${ED}" -name .packlist -print0 | xargs -0 rm -f
	fi

	rm -f "${ED}"/usr/bin/*test
	rm -f "${ED}"/usr/share/man/man1/*test.1*
}
