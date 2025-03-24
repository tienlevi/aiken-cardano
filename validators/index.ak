use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/transaction/credential.{VerificationKey}
use aiken/interval.{Finite}
use aiken/transaction.{Transaction,ScriptContext,Spend,ValidityRange}

type Datum {
    time: Int,
    owner: VerificationKeyHash,
    beneficiary: VerificationKeyHash,
}

fn signed(transaction:Transaction, keyHash: VerificationKeyHash){
    list.has(transaction.extra_signatories,keyHash)
}

fn start(range: ValidityRange, time){
    when range.upper_bound.bound_type is {
        Finite(tx_time) -> time >= tx_time
        _ -> False
    }
}

validator vesting {
    vesting(datum: Datum, _redeemer: Void, context: ScriptContext) {
    when context.purpose is {
        Spend(_) -> or {
            signed(context.transaction,datum.owner),
            and {
                signed(context.transaction,datum.beneficiary),
                start(context.transaction.validity_range,datum.time),
            }
        }
        _ -> False
    }
}
}




