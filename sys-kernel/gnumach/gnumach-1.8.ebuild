# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic toolchain-funcs

DESCRIPTION="GNU Mach Kernel"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/gnumach.html"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/gnumach.git"
	inherit autotools git-r3
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

	KEYWORDS="~x86"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"
IUSE="headers-only"

if is_crosspkg ; then
	DEPEND="
		!headers-only? ( cross-${CTARGET}/mig )
	"
else
	DEPEND="
		dev-util/mig
	"
fi

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	if target_is_not_host ; then
		local sysroot=/usr/${CTARGET}

		if use headers-only ; then
			# Assume we don't have working cross-compiler
			export CC=$(tc-getBUILD_CC)
		else
			export MIG="${CTARGET}-mig"
		fi
	fi

	local myeconfargs=(
		# MIG machinery relies on this!
		--enable-dependency-tracking
		--prefix="${EPREFIX}${sysroot}/usr"
		--datadir="${EPREFIX}${sysroot}/usr/share"
		--host=${CTARGET}
	)

	export LDFLAGS="$(raw-ldflags)"

	econf "${myeconfargs[@]}"
}

src_compile() {
	use headers-only && return
	default
}

src_test() {
	use headers-only && return
	default
}

src_install() {
	emake DESTDIR="${D}" $(usex headers-only install-data install)

	if target_is_not_host ; then
		# TODO: Is this needed?
		# On hurd gcc expects system headers to be in /include, not /usr/include
		dosym usr/include /usr/${CTARGET}/include

		# Avoid installing manpages into common location to allow
		# multiple Hurd targets.
		# TODO: autoconf var?
		rm -rfv "${ED}"/usr/share/info
		rmdir "${ED}"/usr/share || die
	fi
}
