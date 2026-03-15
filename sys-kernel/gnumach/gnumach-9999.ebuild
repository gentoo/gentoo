# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic toolchain-funcs

DESCRIPTION="GNU Mach microkernel, for the Hurd"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/gnumach.html"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/gnumach.git"
	inherit autotools git-r3
elif [[ ${PV} == *_p* ]] ; then
	MY_PV=${PV%_p*}+git${PV#*_p}
	MY_P=${PN}_${MY_PV}

	# savannah doesn't allow snapshot downloads from cgit as of 2026-03,
	# but the Debian maintainer is also upstream, so just use theirs
	# instead.
	SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.xz"
	S="${WORKDIR}"/${MY_P/_/-}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"
IUSE="headers-only"
[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~x86"

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

	strip-flags
	# LTO confuses one of the assemble steps
	filter-lto
	# -g3 confuses MIG which relies on preprocessed input
	replace-flags '-g*' '-g1'
	# LD gets invoked directly. raw-ldflags would work here except
	# that it breaks configure which uses the compiler driver
	unset LDFLAGS

	local myeconfargs=(
		# MIG machinery relies on this!
		--enable-dependency-tracking
		--prefix="${EPREFIX}${sysroot}/usr"
		--datadir="${EPREFIX}${sysroot}/usr/share"
		--host=${CTARGET}

		# Needed for QEMU with `-net nic,model=ne2k_pc` at least
		--enable-net-group
	)

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
		# On Hurd, gcc expects system headers to be in /include, not /usr/include
		# TODO: Is this needed?
		dosym usr/include /usr/${CTARGET}/include

		# Avoid collisions for other Hurd targets
		# TODO: autoconf var?
		rm -rfv "${ED}"/usr/share/info || die
		rmdir "${ED}"/usr/share || die
	fi
}
