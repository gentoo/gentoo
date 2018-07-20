# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bsdmk freebsd toolchain-funcs multilib

DESCRIPTION="FreeBSD CDDL (opensolaris/zfs) extra software"
SLOT="0"

IUSE="build"
LICENSE="CDDL GPL-2"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~x86-fbsd"
fi

# sys is required.
EXTRACTONLY="
	cddl/
	contrib/
	usr.bin/
	lib/
	sbin/
	sys/
"

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*
	build? ( sys-apps/baselayout )"

DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )"

S="${WORKDIR}/cddl"

PATCHES=( "${FILESDIR}/${PN}-11.0-workaround.patch"
	"${FILESDIR}/${PN}-11.0-add-libs.patch" )

pkg_setup() {
	# Add the required source files.
	use build && EXTRACTONLY+="include/ "
	[[ $(tc-getCXX) != *clang++* ]] && REMOVE_SUBDIRS="usr.sbin/zfsd"
}

src_prepare() {
	if [[ ! -e "${WORKDIR}/include" ]]; then
		# Link in include headers.
		ln -s "/usr/include" "${WORKDIR}/include" || die "Symlinking /usr/include.."
	fi
	for d in libavl libctf libdtrace libnvpair libumem libuutil libzfs libzfs_core libzpool; do
		LDFLAGS="${LDFLAGS} -L${S}/lib/${d}"
	done
}

src_compile() {
	cd "${S}"/lib || die
	freebsd_src_compile
	cd "${S}" || die
	freebsd_src_compile
}

src_install() {
	# Install libraries proper place
	local mylibdir=$(get_libdir)
	freebsd_src_install SHLIBDIR="/usr/${mylibdir}" LIBDIR="/usr/${mylibdir}"

	gen_usr_ldscript -a avl nvpair umem uutil zfs zpool zfs_core

	# Install zfs volinit script.
	newinitd "${FILESDIR}"/zvol.initd-9.0 zvol

	# Install zfs script
	newinitd "${FILESDIR}"/zfs.initd zfs

	keepdir /etc/zfs
}
