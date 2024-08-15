import { describe, it, expect } from 'vitest';
import { Clarinet, Tx, Chain, Account, types } from "@clarigen/clarinet";

describe('Crowdfunding Contract Tests', () => {
	it('should allow creating a campaign and contributing to it', async () => {
		let chain = new Chain();
		let accounts = new Map<string, Account>();
		
		// Set up accounts
		accounts.set('deployer', { address: 'SP12345...', ... });
		accounts.set('wallet_1', { address: 'SP67890...', ... });
		
		let deployer = accounts.get('deployer')!;
		let wallet_1 = accounts.get('wallet_1')!;
		
		// Create a new campaign
		let block = chain.mineBlock([
			Tx.contractCall(
				'crowdfunding',
				'create-campaign',
				[types.uint(1000), types.uint(10)],
				deployer.address
			),
		]);
		
		expect(block.receipts[0].result).toBe('ok');
		expect(block.receipts[0].result).toContain('uint(0)');
		
		// Contribute to the campaign
		block = chain.mineBlock([
			Tx.contractCall(
				'crowdfunding',
				'contribute',
				[types.uint(0), types.uint(500)],
				wallet_1.address
			),
		]);
		
		expect(block.receipts[0].result).toBe('ok');
		expect(block.receipts[0].result).toContain('bool(true)');
		
		// Check contribution amount
		block = chain.mineBlock([
			Tx.contractCall(
				'crowdfunding',
				'get-contribution',
				[types.uint(0), wallet_1.address],
				deployer.address
			),
		]);
		
		expect(block.receipts[0].result).toBe('ok');
		expect(block.receipts[0].result).toContain('uint(500)');
	});
});
