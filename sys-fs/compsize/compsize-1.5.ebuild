# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utility to find btrfs compression type/ratio on a file or set of files"
HOMEPAGE="https://github.com/kilobyte/compsize"

if [[ ${PV} = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kilobyte/compsize.git"
else
	SRC_URI="https://github.com/kilobyte/compsize/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2+ GPL-2"
IUSE="debug"
SLOT="0"

DEPEND="sys-fs/btrfs-progs"

src_prepare() {
	default
	# Don't try to install a gzipped manfile during emake install
	sed -i -e $'s/\.gz//' -e $'s/gzip.*/install \-Dm755 \$\< \$\@/' Makefile || die
}

src_configure() {
	tc-export CC

	use debug && append-cflags -Wall -DDEBUG -g
	default
}

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}
