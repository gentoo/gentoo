# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

LIBTOOLIZE="true" #225559
WANT_LIBTOOL="none"
inherit autotools epatch epunt-cxx multilib unpacker

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.savannah.gnu.org/${PN}.git
		http://git.savannah.gnu.org/r/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
fi

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="https://www.gnu.org/software/libtool/"

LICENSE="GPL-2"
SLOT="2"
IUSE="vanilla"

# Pull in libltdl directly until we convert packages to the new dep.
RDEPEND="sys-devel/gnuconfig
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.13
	dev-libs/libltdl:0
	!<sys-apps/sandbox-2.10-r4"
DEPEND="${RDEPEND}
	app-arch/xz-utils"
[[ ${PV} == "9999" ]] && DEPEND+=" sys-apps/help2man"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
		cd "${S}"
		./bootstrap || die
	else
		unpacker_src_unpack
	fi
}

src_prepare() {
	use vanilla && return 0

	epatch "${FILESDIR}"/${PN}-2.4.3-use-linux-version-in-fbsd.patch #109105
	epatch "${FILESDIR}"/${P}-link-specs.patch
	epatch "${FILESDIR}"/${P}-link-fsanitize.patch #573744
	epatch "${FILESDIR}"/${P}-link-fuse-ld.patch
	epatch "${FILESDIR}"/${P}-libtoolize-slow.patch
	epatch "${FILESDIR}"/${P}-libtoolize-delay-help.patch
	epatch "${FILESDIR}"/${P}-sed-quote-speedup.patch #542252
	epatch "${FILESDIR}"/${P}-ppc64le.patch #581314
	pushd libltdl >/dev/null
	AT_NOELIBTOOLIZE=yes eautoreconf
	popd >/dev/null
	AT_NOELIBTOOLIZE=yes eautoreconf
	epunt_cxx

	# Make sure timestamps don't trigger a rebuild of man pages. #556512
	if [[ ${PV} != "9999" ]] ; then
		touch doc/*.1
		export HELP2MAN=false
	fi
}

src_configure() {
	# the libtool script uses bash code in it and at configure time, tries
	# to find a bash shell.  if /bin/sh is bash, it uses that.  this can
	# cause problems for people who switch /bin/sh on the fly to other
	# shells, so just force libtool to use /bin/bash all the time.
	export CONFIG_SHELL=/bin/bash

	# Do not bother hardcoding the full path to sed.  Just rely on $PATH. #574550
	export ac_cv_path_SED=$(basename "$(type -P sed)")

	ECONF_SOURCE=${S} econf --disable-ltdl-install
}

src_test() {
	emake check
}

src_install() {
	default

	local x
	while read -d $'\0' -r x ; do
		ln -sf "${EPREFIX}"/usr/share/gnuconfig/${x##*/} "${x}" || die
	done < <(find "${ED}" '(' -name config.guess -o -name config.sub ')' -print0)
}
