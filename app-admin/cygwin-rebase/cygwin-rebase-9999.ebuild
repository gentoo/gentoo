# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Core of the automatic rebase facility during postinstall on Cygwin"
HOMEPAGE="https://cygwin.com"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

inherit autotools

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://sourceware.org/git/cygwin-apps/rebase.git"
	EGIT_REPO_URI="https://github.com/haubi/cygwin-rebase.git"
	EGIT_BRANCH="gentoo"
	inherit git-r3
else
	# Upstream does not provide archived source tarballs from git release tags,
	# only non archived cygwin distro packages with embedded source tarballs.
	# For now, we download from haubi's github mirror repo, having
	# repo name "cygwin-rebase" and tag names like "rebase-4-4-4".
	MY_PN=cygwin-rebase-rebase
	MY_PV=${PV//./-}
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="
		https://github.com/haubi/cygwin-rebase/archive/rebase-${MY_PV}.tar.gz -> ${P}.tar.gz
		https://github.com/haubi/cygwin-rebase/compare/rebase-${MY_PV}...rebase-${MY_PV}_merge-files-flag-0.patch -> ${P}_merge-files-flag-0.patch
	"
	PATCHES=( "${DISTDIR}/${P}_merge-files-flag-0.patch" )
	KEYWORDS="-* ~x64-cygwin ~x86-cygwin"
fi

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	# do not bother upstream with bug reports yet
	sed -e "/AC_INIT/{s|rebase|${PN}|;s|cygwin@cygwin.com|https://bugs.gentoo.org/|}" \
		-i configure.ac || die
	eautoreconf
}

src_configure() {
	econf --with-posix-shell="${BASH}"
}

src_install() {
	default
	# do not work nor make so much sense in Gentoo Prefix
	rm -f "${ED}"/usr/bin/{rebase,peflags}all || die
}

pkg_preinst() {
	local rebasedb
	local baseaddr
	case ${CHOST} in
	i686-*-cygwin*)
		rebasedb=/etc/rebase.db.i386
		baseaddr=0x70000000
		;;
	x86_64-*-cygwin*)
		rebasedb=/etc/rebase.db.x86_64
		baseaddr=0x1000000000
		;;
	esac
	[[ ${rebasedb} ]] || die "CHOST ${CHOST} is not supported for ${PN}."

	[[ -s ${EROOT}${rebasedb} ]] && return 0

	einfo "Creating initial rebase database with default base address ${baseaddr}..."
	cp /bin/cygwin1.dll "${T}/initial.dll" || die
	"${ED}/usr/bin/rebase" --verbose "--base=${baseaddr}" --database "${T}/initial.dll" || die
	eend $?
}
