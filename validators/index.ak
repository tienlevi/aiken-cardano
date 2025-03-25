use aiken/collection/list
use aiken/interval.{Interval,IntervalBound}
use aiken/crypto.{VerificationKeyHash,VerificationKey}
use aiken/interval.{Finite}
use cardano/transaction.{Transaction,Spend,ValidityRange}
use cardano/script_context.{ScriptContext}
use types/context.{Context}

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

test main(){
    let interval: Interval<Int> = Interval
    { lower_bound:
      IntervalBound { bound_type: Finite(1), is_inclusive: True }
    , upper_bound:
      IntervalBound { bound_type: Finite(10), is_inclusive: True }
    }
    start(interval,1000)
}

// validator vesting {
//     vesting(datum: Datum, _redeemer: Void, context: Context<a>) {
//     when context is {
//         Spend(_) -> True
//         _ -> False
//     }
// }
// }




