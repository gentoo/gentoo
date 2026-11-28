# Copyright 2017-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo optfeature pam systemd git-r3

DESCRIPTION="ipc based login daemon"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/greetd/"
EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/greetd"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
IUSE="selinux"

DEPEND="
	acct-user/greetd
	sys-auth/pambase
	sys-libs/pam
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="app-text/scdoc"

QA_FLAGS_IGNORED="usr/bin/.*greet.*"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default

	# Match the Gentoo greetd user and keep the greeter off tty1.
	sed -i \
		-e 's/^vt = 1$/vt = 7/' \
		-e 's/^user = "greeter"$/user = "greetd"/' \
		config.toml || die
}

src_compile() {
	cargo_src_compile
	scdoc < ./man/agreety-1.scd > ./agreety.1 || die
	scdoc < ./man/greetd-1.scd > ./greetd.1 || die
	scdoc < ./man/greetd-5.scd > ./greetd.5 || die
	scdoc < ./man/greetd-ipc-7.scd > ./greetd-ipc.7 || die
}

src_install() {
	dobin "$(cargo_target_dir)"/{agreety,fakegreet,greetd}

	insinto /etc/greetd
	doins config.toml

	systemd_dounit greetd.service

	doman agreety.1 greetd.1 greetd.5 greetd-ipc.7

	newpamd - greetd <<-EOF
		# newer greetd errors when no greetd-specific pam.d config is
		# available
		# workaround by just using the fallback that it was already
		# using anyway
		auth            include         login
		account         include         login
		password        include         login
		session         include         login
	EOF
}

pkg_postint() {
	optfeature "eye-candy gtk based greeter" gui-apps/gtkgreet
	optfeature "simplistic but sleek terminal greeter" gui-apps/tuigreet
}
