# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

# Two tests fails but the README already indicates that this may not
# work. Additionally these tests require access to video devices such as
# /dev/nvidiactl.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_NAME="opengl"

RUBY_FAKEGEM_EXTRADOC="History.md README.rdoc"

RUBY_FAKEGEM_EXTENSIONS=(ext/opengl/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=(lib/opengl)

inherit ruby-fakegem

DESCRIPTION="OpenGL / GLUT bindings for ruby"
HOMEPAGE="https://github.com/larskanis/opengl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"

IUSE=""

DEPEND+=" virtual/opengl
	media-libs/freeglut"
RDEPEND+=" virtual/opengl
	media-libs/freeglut"

all_ruby_install() {
	all_fakegem_install

	dodoc -r examples
}
