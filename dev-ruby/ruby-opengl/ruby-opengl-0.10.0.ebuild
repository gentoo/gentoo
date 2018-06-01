# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

# Two tests fails but the README already indicates that this may not
# work. Additionally these tests require access to video devices such as
# /dev/nvidiactl.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_NAME="opengl"

RUBY_FAKEGEM_EXTRADOC="History.md README.rdoc"

inherit multilib ruby-fakegem

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

each_ruby_configure() {
	${RUBY} -Cext/opengl extconf.rb || die
}

each_ruby_compile() {
	emake -C ext/opengl V=1

	cp ext/*/*$(get_modname) lib/opengl/ || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/examples
	doins -r examples/*
}
