# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils python multilib

DESCRIPTION="command line tool for interacting with cloud storage services"
HOMEPAGE="https://code.google.com/p/gsutil/"
SRC_URI="http://commondatastorage.googleapis.com/pub/${PN}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-python/boto-2.5.2"

S=${WORKDIR}/${PN}

src_prepare() {
	# use system boto
	rm -rf boto
	epatch "${FILESDIR}"/${PN}-system-boto.patch

	# use the custom internal path to avoid polluting python system
	sed -i \
		-e "/^gsutil_bin_dir =/s:=.*:= '/usr/$(get_libdir)/${PN}';sys.path.insert(0, gsutil_bin_dir);:" \
		gsutil || die

	# trim some cruft
	find gslib third_party -name README -delete
}

src_install() {
	dobin gsutil || die

	insinto /usr/$(get_libdir)/${PN}
	doins -r gslib oauth2_plugin third_party VERSION || die

	# https://code.google.com/p/gsutil/issues/detail?id=96
	rm "${D}"/usr/$(get_libdir)/${PN}/gslib/commands/test.py || die

	dodoc README
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r cloud{auth,reader}
	fi
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
