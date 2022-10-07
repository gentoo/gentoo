# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Dump a remote Subversion repository"
HOMEPAGE="http://rsvndump.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+ BSD public-domain"  # rsvndump, snappy-c, critbit89
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="dev-vcs/subversion
	dev-libs/apr
	dev-libs/apr-util
	sys-devel/gettext"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto
		>=app-text/asciidoc-8.4 )"

src_prepare() {
	default

	# We need to patch use of /usr/lib because it is a problem with
	# linker lld with profile 17.1 on amd64 (see https://bugs.gentoo.org/739028).
	# The grep sandwich acts as a regression test so that a future
	# version bump cannot break patching without noticing.
	if [[ $(get_libdir) != lib ]] ; then
		grep -wq svn_prefix/lib m4/find_svn.m4 || die
		sed "s,svn_prefix/lib,svn_prefix/$(get_libdir)," -i m4/find_svn.m4 || die
		grep -w svn_prefix/lib m4/find_svn.m4 && die

		grep -wq SVN_PREFIX/lib configure.ac || die
		sed "s,SVN_PREFIX/lib,SVN_PREFIX/$(get_libdir)," -i configure.ac || die
		grep -w SVN_PREFIX/lib configure.ac && die
	fi

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc man) \
		$(use_enable debug)
}
