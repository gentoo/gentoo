# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils user

DESCRIPTION="Extended ROOT remote file server"
HOMEPAGE="http://xrootd.org/"
SRC_URI="http://xrootd.org/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fuse http kerberos readline ssl test"

RDEPEND="
	!<sci-physics/root-5.32[xrootd]
	sys-libs/zlib
	fuse? ( sys-fs/fuse )
	kerberos? ( virtual/krb5 )
	readline? ( sys-libs/readline:0= )
	ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	test? ( dev-util/cppunit )"

REQUIRED_USE="http? ( kerberos ssl )"
PATCHES=( "${FILESDIR}"/${PN}-no-werror.patch )

pkg_setup() {
	enewgroup xrootd
	enewuser xrootd -1 -1 "${EPREFIX}"/var/spool/xrootd xrootd
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_FUSE=$(usex fuse)
		-DENABLE_HTTP=$(usex http)
		-DENABLE_KRB5=$(usex kerberos)
		-DENABLE_READLINE=$(usex readline)
		-DENABLE_CRYPTO=$(usex ssl)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_CEPH=OFF
		-DENABLE_PYTHON=OFF # TODO: install python bindings properly
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	use doc && HTML_DOCS=( doxydoc/html/. )
	dodoc docs/ReleaseNotes.txt
	cmake-utils_src_install
	find "${D}" \( -iname '*.md5' -o -iname '*.map' \) -delete || die

	# base configs
	insinto /etc/xrootd
	doins packaging/common/*.cfg

	fowners root:xrootd /etc/xrootd
	keepdir /var/log/xrootd
	fowners xrootd:xrootd /var/log/xrootd

	local i
	for i in cmsd frm_purged frm_xfrd xrootd; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
	done
	# all daemons MUST use single master config file
	newconfd "${FILESDIR}"/xrootd.confd xrootd
}
