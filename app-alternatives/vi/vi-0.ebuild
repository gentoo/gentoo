# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"vim:>=app-editors/vim-9.0.0828-r2"
	"busybox:sys-apps/busybox"
	"elvis:>=app-editors/elvis-2.2.0-r9"
	"gvim:>=app-editors/gvim-9.0.0828-r2"
	"nvim:>=app-editors/neovim-0.8.1-r1"
	"pyvim:>=app-editors/pyvim-3.0.3-r1"
	"vile:>=app-editors/vile-9.8w"
	"vis:>=app-editors/vis-0.8-r1"
	"xvile:app-editors/xvile"
)

inherit app-alternatives

DESCRIPTION="/usr/bin/vi, ex and view symlinks"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="split-usr"

RDEPEND="
	!app-eselect/eselect-vi
"

src_install() {
	local alt=$(get_alternative)
	local root_prefix=
	use split-usr && root_prefix=../../bin/

	case ${alt} in
		busybox)
			dosym "${root_prefix}${alt}" /usr/bin/vi || die
			;;
		*)
			dosym "${alt}" /usr/bin/vi || die
			# TODO: should we symlink them even if they don't provide ex mode?
			dosym vi /usr/bin/ex || die
			dosym vi /usr/bin/view || die
			;;
	esac

	case ${alt} in
		busybox)
			newman - vi.1 <<<".so ${alt}.1"
			;;
		pyvim)
			;;
		xvile)
			# TODO: or maybe link to vile?
			;;
		*)
			newman - vi.1 <<<".so ${alt}.1"
			newman - ex.1 <<<".so vi.1"
			newman - view.1 <<<".so vi.1"
			;;
	esac
}
