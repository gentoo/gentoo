# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib usr-ldscript

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://gitlab.com/bzip2/bzip2"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.com/bzip2/bzip2"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
fi

LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME

IUSE="static-libs"

PDEPEND="
	app-alternatives/bzip2
"

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		# Requires whole tex stack
		-Ddocs="disabled"
	)

	meson_src_configure
}

multilib_src_install() {
	meson_src_install

	if multilib_is_native_abi ; then
		gen_usr_ldscript -a bz2
	fi
}

multilib_src_install_all() {
	dodir /bin
	mv "${ED}"/usr/bin/bzip2 "${ED}"/bin/bzip2-reference || die
	mv "${ED}"/usr/share/man/man1/bzip2{,-reference}.1 || die

	# moved to app-alternatives/bzip2
	rm "${ED}"/usr/bin/{bzcat,bunzip2} || die
	rm "${ED}"/usr/share/man/man1/{bzcat,bunzip2.1} || die

	dosym bzdiff /usr/bin/bzcmp
	dosym bzmore /usr/bin/bzless
	local x
	for x in bz{e,f}grep ; do
		dosym bzgrep /usr/bin/${x}
	done

	dosym bzip2-reference.1 /usr/share/man/man1/bzip2recover.1

	einstalldocs
}
