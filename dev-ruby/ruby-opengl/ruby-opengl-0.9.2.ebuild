# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""

# Two tests fails but the README already indicates that this may not
# work. Additionally these tests require access to video devices such as
# /dev/nvidiactl.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_NAME="opengl"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="OpenGL / GLUT bindings for ruby"
HOMEPAGE="https://github.com/larskanis/opengl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

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

	cp ext/*/*$(get_modname) lib/ || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/examples
	doins -r examples/*
}
