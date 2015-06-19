# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.11.2.ebuild,v 1.4 2015/04/08 07:30:33 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils autotools flag-o-matic perl-module python-single-r1 versionator

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="http://www.rpm.org"
SRC_URI="http://rpm.org/releases/rpm-$(get_version_component_range 1-2).x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="nls python doc caps lua acl selinux"

CDEPEND="!app-arch/rpm5
	>=sys-libs/db-4.5
	>=sys-libs/zlib-1.2.3-r1
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	virtual/libintl
	>=dev-lang/perl-5.8.8
	dev-libs/nss
	python? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	lua? ( >=dev-lang/lua-5.1.0[deprecated] )
	acl? ( virtual/acl )
	caps? ( >=sys-libs/libcap-2.0 )"

DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-rpm )"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-4.11.0-autotools.patch \
		"${FILESDIR}"/${PN}-4.8.1-db-path.patch \
		"${FILESDIR}"/${PN}-4.9.1.2-libdir.patch

	# fix #356769
	sed -i 's:%{_var}/tmp:/var/tmp:' macros.in || die "Fixing tmppath failed"

	eautoreconf

	# Prevent automake maintainer mode from kicking in (#450448).
	touch -r Makefile.am preinstall.am
}

src_configure() {
	append-cppflags -I"${EPREFIX}/usr/include/nss" -I"${EPREFIX}/usr/include/nspr"
	econf \
		--without-selinux \
		--with-external-db \
		--without-beecrypt \
		$(use_enable python) \
		$(use_with doc hackingdocs) \
		$(use_enable nls) \
		$(use_with lua) \
		$(use_with caps cap) \
		$(use_with acl)
}

src_compile() {
	default
}

src_install() {
	default

	# remove la files
	prune_libtool_files --all

	mv "${ED}"/bin/rpm "${ED}"/usr/bin
	rmdir "${ED}"/bin
	# fix symlinks to /bin/rpm (#349840)
	for binary in rpmquery rpmverify;do
		ln -sf rpm "${ED}"/usr/bin/${binary}
	done

	use nls || rm -rf "${ED}"/usr/share/man/??

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CHANGES CREDITS GROUPS README*
	if use doc; then
		pushd doc/hacking/html
		dohtml -p hacking -r .
		popd
		pushd doc/librpm/html
		dohtml -p librpm -r .
		popd
	fi

	# Fix perllocal.pod file collision
	perl_delete_localpod
}

pkg_postinst() {
	if [[ -f "${EROOT}"/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${EROOT}"/usr/bin/rpmdb --rebuilddb --root="${EROOT}"
	else
		einfo "No RPM database found... Creating database..."
		"${EROOT}"/usr/bin/rpmdb --initdb --root="${EROOT}"
	fi
}
