# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cdrom desktop unpacker wrapper

DESCRIPTION="Tribes 2 - Team Combat on an Epic Scale"
HOMEPAGE="http://www.lokigames.com/products/tribes2/"
SRC_URI="http://www.libsdl.org/projects/${PN}/release/${P}-cdrom-x86.run"
S="${WORKDIR}"

LICENSE="LOKI-EULA"
SLOT="0"
# This package is broken and doesn't patch right on AMD64.  I've not taken the
# time to try to figure it out but this definitely needs to stay -amd64 until
# someone does fix the patching.
KEYWORDS="-amd64 ~x86"
RESTRICT="mirror bindist strip"

DEPEND="
	games-util/loki_patch
	sys-libs/glibc
"
RDEPEND="
	${DEPEND}
	virtual/opengl
"

dir=opt/${PN}
Ddir="${ED}"/${dir}

pkg_setup() {
	ewarn "The installed game takes about 507MB of space!"
}

src_unpack() {
	cdrom_get_cds README.tribes2d
	unpack_makeself
}

src_install() {
	einfo "Copying files... this may take a while..."
	exeinto "${dir}"
	doexe "${CDROM_ROOT}"/bin/x86/glibc-2.1/{t2launch,tribes2,tribes2.dynamic,tribes2d,tribes2d-restart.sh,tribes2d.dynamic}

	insinto "${dir}"
	doins "${CDROM_ROOT}"/{README,README.tribes2d,Tribes2_Manual.pdf,console_start.cs,kver.pub} "${Ddir}"

	# Video card profiles
	# TODO: move this to src_unpack where it belongs.
	tar xzf ${CDROM_ROOT}/profiles.tar.gz -C "${Ddir}" || die

	# Base (Music, Textures, Maps, etc.)
	doins -r ${CDROM_ROOT}/base ${CDROM_ROOT}/menu

	cd "${S}"
	loki_patch --verify patch.dat
	loki_patch patch.dat "${Ddir}" >& /dev/null || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' + || die

	newicon "${CDROM_ROOT}"/icon.xpm tribes2.xpm
	make_wrapper t2launch ./t2launch "${dir}" "${dir}"
	make_desktop_entry t2launch "Tribes 2" tribes2
}

pkg_postinst() {
	elog "To play the game run:"
	elog " t2launch"
}
