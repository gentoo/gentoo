# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage active Wine slots and variants"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Wine"
SRC_URI="https://dev.gentoo.org/~ionen/distfiles/${P}.tar.xz"
#SRC_URI="https://gitweb.gentoo.org/proj/eselect-wine.git/snapshot/${P}.tar.bz2" # not up yet

LICENSE="GPL-2+"
SLOT="0"
# rewrite that really needs testing so it doesn't break any bottles
#KEYWORDS="~amd64 ~x86"

RDEPEND="app-admin/eselect"

pkg_pretend() {
	# /usr/bin/wine and /usr/include/wine are removed by pkg_preinst's unset,
	# but portage currently checks collisions and errors out /before/ preinst
	if has_version '<app-eselect/eselect-wine-2' &&
		has collision-protect ${FEATURES}
	then
		eerror
		eerror "!Warning! will likely need to either disable FEATURES=collision-protect or"
		eerror "delete ${EROOT}/usr/bin/wine and ${EROOT}/usr/include/wine to merge ${P}"
		eerror "(these files should be orphaned, so default FEATURES=protect-owned is fine)"
		eerror
	fi
}

src_install() {
	insinto /usr/share/eselect/modules
	doins wine.eselect

	keepdir /etc/eselect/wine

	newenvd - 60${PN} <<-EOF
		PATH="${EPREFIX}/etc/eselect/wine/bin"
		MANPATH="${EPREFIX}/etc/eselect/wine/share/man"
		XDG_DATA_DIRS="${EPREFIX}/etc/eselect/wine/share"
	EOF

	# links for building, e.g. wineasio (bug #657748)
	dosym -r /etc/eselect/wine/wine /usr/lib/wine
	dosym -r /etc/eselect/wine/include /usr/include/wine

	# not required, but useful for e.g. binfmt that's not looking in PATH
	# (not doing this for everything as it gets troublesome to track)
	dosym -r /etc/eselect/wine/bin/wine /usr/bin/wine

	einstalldocs
}

pkg_preinst() {
	if has_version '<app-eselect/eselect-wine-2'; then
		# keep copy of still-set 'active' to auto-select same slots
		[[ ! -e ${EROOT}/etc/eselect/wine/active ]] ||
			cp "${EROOT}"/etc/eselect/wine/{active,eselect-wine-migration} || die

		# managed differently, need cleanup
		eselect wine unset --all || die
		rm -f "${EROOT}"/etc/eselect/wine/{active,installed,links/{any,vanilla,staging,proton,wine}} || die
		rmdir "${EROOT}"/etc/eselect/wine/links 2>/dev/null

		# some rare man dirs were created by old eselect, cleanup if now empty
		rmdir "${EROOT}"/usr/share/man/{de,fr,pl}.UTF-8{/man1,} 2>/dev/null
	fi

	# lacking QA_BROKEN_SYMLINK, and rather avoid live /usr changes wrt
	# bug #632576, nor create "owned" placeholders that will be clobbered
	[[ -e ${EROOT}/etc/eselect/wine/bin/wine ]] ||
		eqawarn "QA Note: broken symlinks QA is normal on first merge, targets created after"
}

pkg_postinst() {
	eselect wine update --if-unset || die

	rm -f "${EROOT}"/etc/eselect/wine/eselect-wine-migration || die # see preinst

	if [[ ! ${REPLACING_VERSIONS##* } ]] ||
		ver_test ${REPLACING_VERSIONS##* } -lt 2; then
		elog
		if [[ ${REPLACING_VERSIONS} ]]; then
			elog "Note: if seen bin/wine or include/wine collision messages, it is harmless"
			elog "${PN} changed a bit, suggest reviewing 'eselect wine help' (and list)."
		fi
		elog "Please run '. ${EROOT}/etc/profile' to update PATH in current shells."
	fi
}

pkg_prerm() {
	[[ ${REPLACED_BY_VERSION} ]] || eselect wine update --reset # no die
}
