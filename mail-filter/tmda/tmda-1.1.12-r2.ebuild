# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Python-based SPAM reduction system"
HOMEPAGE="http://www.tmda.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	virtual/mta
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

PATCHES=(
	# Do not open /dev/tty when in batch mode. (bug #67150) -ticho
	"${FILESDIR}/tmda-1.0-non-interactive-tty.patch"
)

src_install() {
	# Executables
	python_doscript bin/tmda-*

	# The Python TMDA module
	python_domodule TMDA

	# The templates
	insinto /etc/tmda
	doins templates/*.txt

	# Documentation
	dodoc ChangeLog CODENAMES CRYPTO NEWS README THANKS UPGRADE
	dodoc -r doc/html

	# Contributed binaries and stuff
	cd contrib || die

	exeinto /usr/$(get_libdir)/tmda/contrib
	doexe collectaddys def2html printcdb printdbm \
	      sendit.sh smtp-check-sender update-internaldomains vadduser-tmda \
	      vmailmgr-vdir.sh vpopmail-vdir.sh wrapfd3.sh

	insinto /usr/$(get_libdir)/tmda/contrib
	doins ChangeLog tmda.el tmda.spec \
	      tofmipd.init tofmipd.sysconfig vtmdarc
	doins -r dot-tmda
}
