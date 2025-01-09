# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-${PV:0:3}-${PV:4}"
DESCRIPTION="bash source code debugging"
HOMEPAGE="http://bashdb.sourceforge.net/"

if [[ ${PV} == *_pre* ]] ; then
	inherit autotools

	# bashdb for newer bash versions doesn't (yet?) have tags, so we
	# take snapshots. Make sure to pick the right branch.
	BASHDB_COMMIT="11150b3bee22215632143942ade99b5f2441c4ca"
	SRC_URI="
		https://github.com/Trepan-Debuggers/bashdb/archive/${BASHDB_COMMIT}.tar.gz -> ${P}.gh.tar.gz
	"
	S="${WORKDIR}"/${PN}-${BASHDB_COMMIT}
else
	SRC_URI="
		https://downloads.sourceforge.net/bashdb/${MY_P}.tar.bz2
	"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="app-shells/bash:${PV:0:3}"
RDEPEND="${DEPEND}"

# test-bug-loc fails with formatting differences
RESTRICT="test"

src_prepare() {
	default

	[[ ${PV} == *_pre* ]] && eautoreconf

	# We don't install this, so don't bother building it. #468044
	sed -i 's:texi2html:true:' doc/Makefile.in || die
}

src_configure() {
	# This path matches the bash sources.  If we ever change bash,
	# we'll probably have to change this to match (bug #591994).
	CONFIG_SHELL="${BROOT}"/bin/bash econf \
		--with-bash="${EPREFIX}"/bin/bash-${PV:0:3} \
		--with-dbg-main='$(PKGDATADIR)/bashdb-main.inc'
}
