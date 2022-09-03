# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES=( fr it ja pl ru )

inherit autotools bash-completion-r1

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vim/vim.git"
	EGIT_CHECKOUT_DIR=${WORKDIR}/vim-${PV}
else
	SRC_URI="https://github.com/vim/vim/archive/v${PV}.tar.gz -> vim-core-${PV}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
S="${WORKDIR}/vim-${PV}/src"

DESCRIPTION="Hexdump utility from vim"
HOMEPAGE="https://vim8.org/ https://github.com/vim/vim"

# X11-MIT or GPL-2 license for src/xxd/*. X11-MIT isn't in the gentoo tree and
# not much sense in adding it as it's optional.
LICENSE="GPL-2"
SLOT="0"
IUSE="${PLOCALES[@]/#/l10n_}"

RDEPEND="!<app-editors/vim-core-9.0.0099-r1"

src_prepare() {
	# let portage do the stripping
	sed -i \
		's|^#STRIP = /bin/true|STRIP = /bin/true|' \
		Makefile || die "Makefile sed failed"

	# sed out all non-xxd stuff from "installtools" target
	sed -i \
		-e 's|\$(DEST_VIM) \$(DEST_RT) \$(DEST_TOOLS) \\||' \
		-e '/^# install the runtime tools/,/^# install the language specific files/{//!d;}' \
		Makefile || die "Makefile sed failed"

	# remove localized man pages not set in L10N
	for lang in ${PLOCALES[@]}; do
		if ! use l10n_${lang}; then
			rm -f ../runtime/doc/xxd-${lang}*.1 || die "rm -f failed"
		fi
	done

	eapply_user
	eautoconf
}

src_configure() {
	local myconf=(
		--with-modified-by=Gentoo-${PVR}
		--enable-gui=no
		--without-x
		--disable-darwin
		--disable-perlinterp
		--disable-pythoninterp
		--disable-rubyinterp
		--disable-gpm
		--disable-selinux
		--disable-nls
		--disable-acl
	)

	econf "${myconf[@]}"
}

src_compile() {
	emake xxd/xxd
}

src_install() {
	emake installtools install-tool-languages \
		DESTDIR="${D}" \
		BINDIR="${EPREFIX}"/usr/bin \
		MANDIR="${EPREFIX}"/usr/share/man \
		DATADIR="${EPREFIX}"/usr/share

	newbashcomp "${FILESDIR}"/xxd-completion xxd
}
