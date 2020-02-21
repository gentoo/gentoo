# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Guile bindings of git"
HOMEPAGE="https://gitlab.com/guile-git/guile-git"
SRC_URI="https://gitlab.com/guile-git/guile-git/uploads/160f6a36c1be8d4fc1990a193081a04d/guile-git-${PV}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-scheme/guile-2.0.11:=
	dev-scheme/bytestructures
	dev-libs/libgit2:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# guile is trying to avoid recompilation by checking if file
	#     /usr/lib64/guile/2.2/site-ccache/<foo>
	# is newer than
	#     <foo>
	# In case it is instead of using <foo> guile
	# loads system one (from potentially older version of package).
	# To work it around we bump last modification timestamp of
	# '*.scm' files.
	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_test() {
	emake check VERBOSE=1
}
