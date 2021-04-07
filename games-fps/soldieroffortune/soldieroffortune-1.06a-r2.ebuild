# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHECKREQS_DISK_BUILD="1450M"
CHECKREQS_DISK_USR="725M"
inherit cdrom check-reqs desktop unpacker wrapper

DESCRIPTION="First-person shooter based on the mercenary trade"
HOMEPAGE="http://www.lokigames.com/products/sof/"
SRC_URI="mirror://lokigames/sof/sof-${PV}-cdrom-x86.run"
S="${WORKDIR}"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip mirror bindist"

RDEPEND="
	media-libs/libsdl[X,opengl,sound,abi_x86_32(-)]
	media-libs/smpeg[abi_x86_32(-)]
	sys-libs/glibc
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	amd64? ( sys-libs/glibc[multilib] )
"
BDEPEND="games-util/loki_patch"

dir=opt/${PN}
Ddir="${ED}"/${dir}
unpackDir="${T}"/unpack

pkg_pretend() {
	check-reqs_pkg_pretend
}

src_unpack() {
	cdrom_get_cds sof.xpm
	unpack_makeself
	mkdir ${unpackDir} || die
	tar xzf "${CDROM_ROOT}"/paks.tar.gz -C "${unpackDir}" || die
	tar xzf "${CDROM_ROOT}"/binaries.tar.gz -C "${unpackDir}" || die
}

src_install() {
	einfo "Copying files... this may take a while..."

	exeinto ${dir}
	doexe "${CDROM_ROOT}"/bin/x86/glibc-2.1/sof

	insinto ${dir}
	doins -r "${unpackDir}"/*
	doins "${CDROM_ROOT}"/{README,kver.pub,sof.xpm}

	cd "${S}" || die
	export _POSIX2_VERSION=199209
	loki_patch --verify patch.dat || die
	loki_patch patch.dat "${Ddir}" >& /dev/null || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' + || die

	make_wrapper sof ./sof "${dir}" "${dir}"

	# Fix buffer overflow
	sed -i -e '/^exec/i \
export MESA_EXTENSION_MAX_YEAR=2003 \
export __GL_ExtensionStringVersion=17700' \
		"${ED}/usr/bin/sof" || die

	doicon "${CDROM_ROOT}"/sof.xpm
	make_desktop_entry sof "Soldier of Fortune" sof
}

pkg_postinst() {
	elog "To play the game run:"
	elog " sof"
}
