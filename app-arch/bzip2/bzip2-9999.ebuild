# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal usr-ldscript

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://gitlab.com/federicomenaquintero/bzip2"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/federicomenaquintero/bzip2.git"
else
	SRC_URI=""
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
fi
LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME

IUSE="static-libs"

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		# Requires whole tex stack
		-Ddocs="disabled"
	)

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	if multilib_is_native_abi ; then
		gen_usr_ldscript -a bz2

		dodir /bin
		mv "${ED}"/usr/bin/bzip2 "${ED}"/bin || die
	fi
}

multilib_src_install_all() {
	# move "important" bzip2 binaries to /bin and use the shared libbz2.so
	dosym bzip2 /bin/bzcat
	dosym bzip2 /bin/bunzip2

	dosym bzdiff /usr/bin/bzcmp
	dosym bzmore /usr/bin/bzless
	local x
	for x in bz{e,f}grep ; do
		dosym bzgrep /usr/bin/${x}
	done

	dosym bzip2.1 /usr/share/man/man1/bzip2recover.1

	local DOCS=( AUTHORS NEWS{,-pre-1.0.7} README.md )
	einstalldocs
}
