# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit edo python-any-r1

DESCRIPTION="Gentoo Authority Keys (GLEP 79)"
HOMEPAGE="https://www.gentoo.org/downloads/signatures/"
if [[ ${PV} == 9999* ]] ; then
	PROPERTIES="live"

	BDEPEND="net-misc/curl"
else
	SRC_URI="https://qa-reports.gentoo.org/output/keys/active-devs-${PV}.gpg -> ${P}-active-devs.gpg"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~x86"
fi

S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND+="
	$(python_gen_any_dep 'dev-python/python-gnupg[${PYTHON_USEDEP}]')
	sec-keys/openpgp-keys-gentoo-auth
	test? (
		app-crypt/gnupg
	)
"

python_check_deps() {
	python_has_version "dev-python/python-gnupg[${PYTHON_USEDEP}]"
}

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		curl https://qa-reports.gentoo.org/output/active-devs.gpg -o ${P}-active-devs.gpg || die
	else
		default
	fi
}

src_compile() {
	export GNUPGHOME="${T}"/.gnupg

	get_gpg_keyring_dir() {
		if [[ ${PV} == 9999* ]] ; then
			echo "${WORKDIR}"
		else
			echo "${DISTDIR}"
		fi
	}

	local mygpgargs=(
		--no-autostart
		--no-default-keyring
		--homedir "${GNUPGHOME}"
	)

	# From verify-sig.eclass:
	# "GPG upstream knows better than to follow the spec, so we can't
	# override this directory.  However, there is a clean fallback
	# to GNUPGHOME."
	addpredict /run/user

	mkdir "${GNUPGHOME}" || die
	chmod 700 "${GNUPGHOME}" || die

	# Convert the binary keyring into an armored one so we can process it
	edo gpg "${mygpgargs[@]}" --import "$(get_gpg_keyring_dir)"/${P}-active-devs.gpg
	edo gpg "${mygpgargs[@]}" --export --armor > "${WORKDIR}"/gentoo-developers.asc

	# Now strip out the keys which are expired and/or missing a signature
	# from our L2 developer authority key
	edo "${EPYTHON}" "${FILESDIR}"/keyring-mangler.py \
			"${BROOT}"/usr/share/openpgp-keys/gentoo-auth.asc \
			"${WORKDIR}"/gentoo-developers.asc \
			"${WORKDIR}"/gentoo-developers-sanitised.asc
}

src_test() {
	export GNUPGHOME="${T}"/tests/.gnupg

	local mygpgargs=(
		# We don't have --no-autostart here because we need
		# to let it spawn an agent for the key generation.
		--no-default-keyring
		--homedir "${GNUPGHOME}"
	)

	# From verify-sig.eclass:
	# "GPG upstream knows better than to follow the spec, so we can't
	# override this directory.  However, there is a clean fallback
	# to GNUPGHOME."
	addpredict /run/user

	# Check each of the keys to verify they're trusted by
	# the L2 developer key.
	mkdir -p "${GNUPGHOME}" || die
	chmod 700 "${GNUPGHOME}" || die
	cd "${T}"/tests || die

	# First, grab the L1 key, and mark it as ultimately trusted.
	edo gpg "${mygpgargs[@]}" --import "${BROOT}"/usr/share/openpgp-keys/gentoo-auth.asc
	edo gpg "${mygpgargs[@]}" --import-ownertrust "${BROOT}"/usr/share/openpgp-keys/gentoo-auth-ownertrust.txt

	# Generate a temporary key which isn't signed by anything to check
	# whether we're detecting unexpected keys.
	#
	# The test is whether this appears in the sanitised keyring we
	# produce in src_compile (it should not be in there).
	#
	# https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html
	edo gpg "${mygpgargs[@]}" --batch --gen-key <<-EOF
		%echo Generating temporary key for testing...

		%no-protection
		%transient-key
		%pubring ${P}-ebuild-test-key.asc

		Key-Type: 1
		Key-Length: 2048
		Subkey-Type: 1
		Subkey-Length: 2048
		Name-Real: Larry The Cow
		Name-Email: larry@example.com
		Expire-Date: 0
		Handle: ${P}-ebuild-test-key

		%commit
		%echo Temporary key generated!
	EOF

	# Import the new injected key that shouldn't be signed by anything into a temporary testing keyring
	edo gpg "${mygpgargs[@]}" --import "${T}"/tests/${P}-ebuild-test-key.asc

	# Sign a tiny file with the to-be-injected key for testing rejection below
	echo "Hello world!" > "${T}"/tests/signme || die
	edo gpg "${mygpgargs[@]}" -u "Larry The Cow <larry@example.com>" --sign "${T}"/tests/signme || die

	edo gpg "${mygpgargs[@]}" --export --armor > "${T}"/tests/tainted-keyring.asc

	# keyring-mangler.py should now produce a keyring *without* it
	edo "${EPYTHON}" "${FILESDIR}"/keyring-mangler.py \
			"${BROOT}"/usr/share/openpgp-keys/gentoo-auth.asc \
			"${T}"/tests/tainted-keyring.asc \
			"${T}"/tests/gentoo-developers-sanitised.asc | tee "${T}"/tests/keyring-mangler.log
	assert "Key mangling in tests failed?"

	# Check the log to verify the injected key got detected
	grep -q "Dropping key.*Larry The Cow" "${T}"/tests/keyring-mangler.log || die "Did not remove injected key from test keyring!"

	# gnupg doesn't have an easy way for us to actually just.. ask
	# if a key is known via WoT. So, sign a file using the key
	# we just made, and then try to gpg --verify it, and check exit code.
	#
	# Let's now double check by seeing if a file signed by the injected key
	# is rejected.
	if gpg "${mygpgargs[@]}" --keyring "${T}"/tests/gentoo-developers-sanitised.asc --verify "${T}"/tests/signme.gpg ; then
		die "'gpg --verify' using injected test key succeeded! This shouldn't happen!"
	fi

	# Bonus lame sanity check
	edo gpg "${mygpgargs[@]}" --check-trustdb 2>&1 | tee "${T}"/tests/trustdb.log
	assert "trustdb call failed!"

	check_trust_levels() {
		local mode=${1}

		while IFS= read -r line; do
			# gpg: depth: 0  valid:   1  signed:   2  trust: 0-, 0q, 0n, 0m, 0f, 1u
			# gpg: depth: 1  valid:   2  signed:   0  trust: 0-, 0q, 0n, 0m, 2f, 0u
			if [[ ${line} == *depth* ]] ; then
				depth=$(echo ${line} | grep -Po "depth: [0-9]")
				trust=$(echo ${line} | grep -Po "trust:.*")

				trust_uncalculated=$(echo ${trust} | grep -Po "[0-9]-")
				[[ ${trust_uncalculated} == 0 ]] || ${mode}

				trust_insufficient=$(echo ${trust} | grep -Po "[0-9]q")
				[[ ${trust_insufficient} == 0 ]] || ${mode}

				trust_never=$(echo ${trust} | grep -Po "[0-9]n")
				[[ ${trust_never} == 0 ]] || ${mode}

				trust_marginal=$(echo ${trust} | grep -Po "[0-9]m")
				[[ ${trust_marginal} == 0 ]] || ${mode}

				trust_full=$(echo ${trust} | grep -Po "[0-9]f")
				[[ ${trust_full} != 0 ]] || ${mode}

				trust_ultimate=$(echo ${trust} | grep -Po "[0-9]u")
				[[ ${trust_ultimate} == 1 ]] || ${mode}

				echo "${trust_uncalculated}, ${trust_insufficient}"
			fi
		done < "${T}"/tests/trustdb.log
	}

	# First, check with the bad key still in the test keyring.
	# This is supposed to fail, so we want it to return 1
	check_trust_levels "return 1" && die "Trustdb passed when it should have failed!"

	# Now check without the bad key in the test keyring.
	# This one should pass.
	#
	# Drop the bad key first (https://superuser.com/questions/174583/how-to-delete-gpg-secret-keys-by-force-without-fingerprint)
	keys=$(gpg "${mygpgargs[@]}" --fingerprint --with-colons --batch "Larry The Cow <larry@example.com>" \
		| grep "^fpr" \
		| sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p')

	for key in ${keys[@]} ; do
		nonfatal edo gpg "${mygpgargs[@]}" --batch --yes --delete-secret-keys ${key}
	done

	edo gpg "${mygpgargs[@]}" --batch --yes --delete-keys "Larry The Cow <larry@example.com>"
	check_trust_levels "return 0" || die "Trustdb failed when it should have passed!"

	gpgconf --kill gpg-agent || die
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins gentoo-developers-sanitised.asc gentoo-developers.asc

	# TODO: install an ownertrust file like sec-keys/openpgp-keys-gentoo-auth?
}
