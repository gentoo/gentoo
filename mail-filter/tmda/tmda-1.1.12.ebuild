# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit eutils multilib python

DESCRIPTION="Python-based SPAM reduction system"
HOMEPAGE="http://www.tmda.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="virtual/mta"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Do not open /dev/tty when in batch mode. (bug #67150) -ticho
	epatch "${FILESDIR}/tmda-1.0-non-interactive-tty.patch"

	python_convert_shebangs -r $(python_get_version) bin
}

src_install() {
	# Executables
	dobin bin/tmda-* || die "dobin failed"

	# The Python TMDA module
	insinto $(python_get_sitedir)
	doins -r TMDA || die "doins failed"

	# The templates
	insinto /etc/tmda
	doins templates/*.txt || die "doins failed"

	# Documentation
	dodoc ChangeLog CODENAMES CRYPTO NEWS README THANKS UPGRADE || die "dodoc failed"
	dohtml -r doc/html/* || die "dohtml failed"

	# Contributed binaries and stuff
	pushd contrib > /dev/null

	exeinto /usr/$(get_libdir)/tmda/contrib
	doexe collectaddys def2html printcdb printdbm \
	      sendit.sh smtp-check-sender update-internaldomains vadduser-tmda \
	      vmailmgr-vdir.sh vpopmail-vdir.sh wrapfd3.sh || die "doexe failed"

	insinto /usr/$(get_libdir)/tmda/contrib
	doins ChangeLog tmda.el tmda.spec \
	      tofmipd.init tofmipd.sysconfig vtmdarc || die "doins failed"

	insinto /usr/$(get_libdir)/tmda/contrib/dot-tmda
	doins dot-tmda/* || die "doins failed"
	popd > /dev/null
}

pkg_postinst() {
	python_mod_optimize TMDA
}

pkg_postrm() {
	python_mod_cleanup TMDA
}
