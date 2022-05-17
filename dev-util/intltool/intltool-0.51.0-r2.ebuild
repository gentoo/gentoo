# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Internationalization Tool Collection"
HOMEPAGE="https://launchpad.net/intltool/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="
	dev-lang/perl
	dev-perl/XML-Parser
"
RDEPEND="${DEPEND}
	sys-devel/gettext
"
DOCS=( AUTHORS ChangeLog NEWS README TODO doc/I18N-HOWTO )

PATCHES=(
	# Fix handling absolute paths in single file key output, bug #470040
	# https://bugs.launchpad.net/intltool/+bug/1168941
	"${FILESDIR}"/${PN}-0.50.2-absolute-paths.patch
	"${FILESDIR}"/${PN}-0.51.0-perl-5.22.patch
	"${FILESDIR}"/${PN}-0.51.0-perl-5.26.patch
)
