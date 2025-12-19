# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for editor"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

# Add a package to RDEPEND only if the editor:
# - can edit ordinary text files,
# - works on the console,
# - is a "display" or "visual" editor (e.g., using ncurses).

RDEPEND="|| (
	app-editors/nano
	app-editors/dav
	app-editors/e3
	app-editors/ee
	app-editors/emacs:*
	app-editors/emact
	app-editors/ersatz-emacs
	app-editors/fe
	app-editors/helix
	app-editors/jasspa-microemacs
	app-editors/jed
	app-editors/joe
	app-editors/jove
	app-editors/kakoune
	app-editors/levee
	app-editors/lpe
	app-editors/mg
	app-editors/micro
	app-editors/moe
	app-editors/ne
	app-editors/neovim
	app-editors/ng
	app-editors/qemacs
	app-editors/teco
	app-editors/uemacs-pk
	app-editors/vile
	app-editors/vim
	app-editors/gvim
	app-editors/vis
	app-editors/xemacs
	app-editors/zile
	app-misc/mc[edit]
	dev-lisp/cmucl
	mail-client/alpine[-onlyalpine]
)"

# Packages outside app-editors providing an editor:
#	app-misc/mc: mcedit (#62643)
#	dev-lisp/cmucl: hemlock
#	mail-client/alpine: pico
#	sys-apps/busybox: vi
