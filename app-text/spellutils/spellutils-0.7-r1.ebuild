# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="spellutils includes 'newsbody' (useful for spellchecking in mails, etc.)"
HOMEPAGE="http://home.worldonline.dk/byrial/spellutils/"
SRC_URI="http://home.worldonline.dk/byrial/spellutils/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ppc ~sparc ~x86"
IUSE="nls"

DEPEND="nls? ( virtual/libintl )"
RDEPEND="${DEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

DOCS=( NEWS README )

PATCHES=(
	"${FILESDIR}"/0001-allow-running-modern-autoreconf.patch
)

src_prepare() {
	default

	# This is a filthy hack born of the fact that gettext is absolutely insane.
	# It requires you specify exactly which version of gettext you have installed
	# at the time of dist, and the tool to automatically update this explicitly reads
	# from /dev/tty "so that gettextize cannot be abused by non-interactive tools."
	#
	# The gettext docs do, of course, claim this is entirely optional and only
	# needed if you run autopoint. They neglect to mention that running
	# autopoint is mandatory. Failure to do so produces this:
	#
	#   configure.ac:11: installing './compile'
	#   configure.ac:26: error: required file './config.rpath' not found
	#   Makefile.am: installing './depcomp'
	#
	# and the call stack points back to -- you guessed it -- AM_GNU_GETTEXT.
	# Which internally requires config.rpath, a file that is explicitly copied
	# over by autopoint.
	#
	# AM_GNU_GETTEXT helpfully points out in code, rather than in docs:
	#
	#   configure.ac: warning: AM_GNU_GETTEXT is used, but not AM_GNU_GETTEXT_VERSION or AM_GNU_GETTEXT_REQUIRE_VERSION
	#
	# Perhaps what is meant by "The use of this macro is optional; only the
	# autopoint program makes use of it" is that you can deliver a `make dist`
	# tarball that isn't built from publicly distributed versions of
	# configure.ac, since you can add the macro, run autoreconf, then delete
	# the macro and rerun autoreconf. It is a very funny definition of optional.
	local gettext_version=$(gettextize --version | awk '/GNU gettext-tools/{print $NF}' || die)
	sed -i "s/@GETTEXT_VERSION@/${gettext_version}/" configure.in || die
	eautoreconf
	cp po/Makevars.template po/Makevars || die
}

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake CC="$(tc-getCC)"
}
